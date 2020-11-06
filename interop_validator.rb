require 'optparse'

$options = {verbose: false, depth: 1}
OptionParser.new do |opts|
  opts.banner = "Usage: interop_validator.rb [options] <language_id> <expression>"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    $options[:verbose] = v
  end

  opts.on("-d", "--depth [DEPTH]", "Set scan depth (default: 1)") do |v|
    $options[:depth] = Integer(v) rescue nil
  end
end.parse!

if ARGV.length < 2
  puts 'Need at least two positional arguments'
  exit
end

language_id = ARGV[0]

if !Truffle::Interop.languages.include?(language_id)
  puts "No language for id #{language_id} found. Supported languages are #{Truffle::Interop.languages}."
  exit
end

expression = ARGV[1]

puts "> Running on #{RUBY_DESCRIPTION}..."
puts "> Evaluating `#{expression}` for #{language_id}...\n\n"

def validate_interop_members(target, next_targets)
  if !Truffle::Interop.has_members?(target)
    return
  end
  begin
    members = Truffle::Interop.members(target)
  rescue => e
    puts "#{sanitize(target)} has members, but does not expose them (*#{e}*)"
    return
  end
  unreadable = []
  members.each { |member|
    if Truffle::Interop.is_member_readable?(target, member)
      begin
        next_targets.append(Truffle::Interop.read_member(target, member))
      rescue => e
        unreadable.append("- `#{member}` (unreadable: *#{e}*)")
      end
    end
  }
  if !unreadable.empty?
    puts "#### Unreadable member(s) of #{sanitize(target)}"
    puts unreadable.sort.join("\n")
    puts
  end
end

def validate_interop_array(target, next_targets)
  if !Truffle::Interop.has_array_elements?(target)
    return
  end
  begin
    size = Truffle::Interop.array_size(target)
  rescue => e
    puts "#{sanitize(target)} has array elements, but does not report its size (*#{e}*)"
    return
  end
  unreadable = []
  for i in 0..size - 1
    begin
      next_targets.append(Truffle::Interop.read_array_element(target, i))
    rescue => e
      unreadable.append("##{i} (*#{e}*)")
    end
  end
  if !unreadable.empty?
    puts "#### Unreadable array element(s) of #{sanitize(target)}"
    puts unreadable.join(', ')
    puts
  end
end

def validate_interop_number(target)
  if Truffle::Interop.is_number?(target)
    if Truffle::Interop.fits_in_int?(target)
      begin
        Truffle::Interop.as_int(target)
      rescue => e
        puts "#{sanitize(target)} fits into int, but does not allow conversion (*#{e}*)"
      end
    end
    if Truffle::Interop.fits_in_double?(target)
      begin
        Truffle::Interop.as_double(target)
      rescue => e
        puts "#{sanitize(target)} fits into double, but does not allow conversion (*#{e}*)"
      end
    end
    if Truffle::Interop.fits_in_long?(target)
      begin
        Truffle::Interop.as_long(target)
      rescue => e
        puts "#{sanitize(target)} fits into long, but does not allow conversion (*#{e}*)"
      end
    end
  end
end

def validate_interop_string(target)
  if Truffle::Interop.is_string?(target)
    begin
      Truffle::Interop.as_string(target)
    rescue => e
      puts "#{sanitize(target)} is string, but does not allow conversion (*#{e}*)"
    end
  end
end

def validate_interop_type(target, type)
  if Truffle::Interop.send("#{type}?", target)
    begin
      Truffle::Interop.send("as_#{type}", target)
    rescue => e
      puts "#{sanitize(target)} is #{type}, but does not allow conversion (*#{e}*)"
    end
  end
end

$seen_objects = {}

def validate_interop_contract(target, depth)
  # See https://github.com/oracle/truffleruby/issues/2138
  hash_code = Truffle::Interop.identity_hash_code(target)
  if $seen_objects.include?(hash_code)
    return
  end
  $seen_objects[hash_code] = true

  if $options[:verbose]
    puts "Validating #{sanitize(target)}..."
  end

  next_targets = []
  validate_interop_members(target, next_targets)
  validate_interop_array(target, next_targets)
  for type in ['boolean', 'pointer']
    validate_interop_type(target, type)
  end
  validate_interop_number(target)
  validate_interop_string(target)
  if depth > 0
    for t in next_targets
      validate_interop_contract(t, depth - 1)    
    end
  end
end

def sanitize(target)
  text = "`#{target}`"
  text.slice! TruffleRuby.graalvm_home
  text
end

validate_interop_contract(Polyglot.eval(language_id, expression), $options[:depth])
