require 'spec_helper'

describe Camion do
  let(:cilindrada) { 1000 }
  let(:kilometros) { 1000 }
  let(:camion) { described_class.new(cilindrada, kilometros) }

  describe '#initialize' do
    it 'asigna el precio base correcto y los parametros' do
      expect(camion.precio_base).to eq(Camion::PRECIO_BASE)
      expect(camion.cilindrada).to eq(cilindrada)
      expect(camion.kilometros).to eq(kilometros)
    end
  end

  describe '#coeficiente_impositivo' do
    it 'calcula el coeficiente impositivo correctamente para 1000cc' do
      expect(camion.coeficiente_impositivo).to eq(2)
    end

    it 'calcula el coeficiente impositivo correctamente para 2000cc' do
      camion = described_class.new(2000, 1000)
      expect(camion.coeficiente_impositivo).to eq(4)
    end
  end

  describe '#valor_mercado' do
    it 'calcula el valor de mercado correctamente para 1000cc y 1000km' do
      expect(camion.valor_mercado).to eq(1000.0)
    end

    it 'calcula el valor de mercado correctamente para 2000cc y 5000km' do
      camion = described_class.new(2000, 5000)
      expect(camion.valor_mercado).to eq(571.4)
    end
  end
end