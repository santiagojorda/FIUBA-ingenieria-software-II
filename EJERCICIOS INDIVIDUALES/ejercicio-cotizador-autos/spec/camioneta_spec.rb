require 'spec_helper'

describe Camioneta do
  let(:cilindrada) { 2000 }
  let(:kilometros) { 1000 }
  let(:camioneta) { described_class.new(cilindrada, kilometros) }

  describe '#initialize' do
    it 'asigna el precio base correcto y los parametros' do
      expect(camioneta.precio_base).to eq(Camioneta::PRECIO_BASE)
      expect(camioneta.cilindrada).to eq(cilindrada)
      expect(camioneta.kilometros).to eq(kilometros)
    end
  end

  describe '#coeficiente_impositivo' do
    context 'con cilindrada 2000' do
      it 'calcula el coeficiente impositivo correctamente' do
        expect(camioneta.coeficiente_impositivo).to eq(3)
      end
    end

    context 'con cilindrada 1000' do
      let(:cilindrada) { 1000 }
      it 'calcula el coeficiente impositivo correctamente' do
        expect(camioneta.coeficiente_impositivo).to eq(1)
      end
    end

    context 'con cilindrada 1000' do
      let(:cilindrada) { 1000 }
      it 'calcula el coeficiente impositivo correctamente' do
        expect(camioneta.coeficiente_impositivo).to eq(1)
      end
    end
  end

  describe '#valor_mercado' do
    it 'calcula el valor de mercado correctamente para 2000cc y 1000km' do
      expect(camioneta.valor_mercado).to eq(1500.0)
    end

    it 'calcula el valor de mercado correctamente para 1000cc y 5000km' do
      camioneta = described_class.new(1000, 5000)
      expect(camioneta.valor_mercado).to eq(250.0)
    end
  end
end