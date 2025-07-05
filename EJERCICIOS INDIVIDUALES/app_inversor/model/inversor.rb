class Inversor
  def invertir(texto)
    inverso = ''
    texto.each_char do |x|
      en_mayusculas = x.upcase
      en_minusculas = x.downcase
      inverso += if x == en_mayusculas
                   en_minusculas
                 else
                   en_mayusculas
                 end
    end
    inverso
  end
end
