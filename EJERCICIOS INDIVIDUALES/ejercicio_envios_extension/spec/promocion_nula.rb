# frozen_string_literal: true

class PromocionNula

  def initialize
    @fue_invocada = false
  end
  def aplicar(_envio)
    @fue_invocada = true
    0
  end
  def fue_invocada
    @fue_invocada
  end
end
