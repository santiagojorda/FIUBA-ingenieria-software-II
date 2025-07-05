require 'spec_helper'

describe Vehiculo do
  let(:precio_base) { 1000 }
  let(:cilindrada) { 1600 }
  let(:kilometros) { 10000 }
  let(:vehiculo) { described_class.new(precio_base, cilindrada, kilometros) }

  describe '#initialize' do
    it 'asigna correctamente el precio_base, cilindrada valida y kilometros' do
      expect(vehiculo.precio_base).to eq(precio_base)
      expect(vehiculo.cilindrada).to eq(cilindrada)
      expect(vehiculo.kilometros).to eq(kilometros)
    end

    context 'con parámetros inválidos' do
      it 'lanza un error si la cilindrada no es valida' do
        cilindrada_invalida = 1200
        expect { described_class.new(precio_base, cilindrada_invalida, kilometros) }
          .to raise_error(CilindradaInvalidaError)
      end
    end
  end

  describe '#coeficiente_impositivo' do
    it 'calcula el coeficiente correctamente' do
      expect(vehiculo.coeficiente_impositivo).to eq(1)
    end
  end

  describe '#valor_mercado' do
    it 'lanza un error si no se implementa' do
      expect { vehiculo.valor_mercado }.to raise_error(NotImplementedError)
    end
  end
end