require_relative './model/inversor'

entrada = ARGV[0]

if entrada.nil?
  puts 'error: entrada requerida'
  exit 1
end

resultado = Inversor.new.invertir(entrada)

puts resultado
