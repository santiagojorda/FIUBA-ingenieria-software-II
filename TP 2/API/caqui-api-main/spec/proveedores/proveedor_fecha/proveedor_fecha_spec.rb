require 'integration_helper'

RSpec.describe ProveedorFecha do
  it 'levanta un NotImplementedError al llamar a #ahora' do
    clase_sin_implementar = Class.new do
      include ProveedorFecha
    end

    instancia = clase_sin_implementar.new
    expect { instancia.ahora }.to raise_error(NotImplementedError, "El metodo 'ahora' debe ser implementado por la clase que incluye este modulo.")
  end
end
