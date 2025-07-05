require 'spec_helper'

describe Auto do
  let(:cilindrada) { 1000 }
  let(:kilometros) { 1000 }
  let(:auto) { described_class.new(cilindrada, kilometros) }

  describe '#initialize' do
    it 'asigna el precio base correcto y los parametros' do
      expect(auto.precio_base).to eq(Auto::PRECIO_BASE)
      expect(auto.cilindrada).to eq(cilindrada)
      expect(auto.kilometros).to eq(kilometros)
    end
  end

  describe '#coeficiente_impositivo' do
    context 'con cilindrada 1000' do
      it 'calcula el coeficiente impositivo correctamente' do
        expect(auto.coeficiente_impositivo).to eq(1)
      end
    end

    context 'con cilindrada 1600' do
      let(:cilindrada) { 1600 }
      it 'calcula el coeficiente impositivo correctamente' do
        expect(auto.coeficiente_impositivo).to eq(1)
      end
    end

    context 'con cilindrada 2000' do
      let(:cilindrada) { 2000 }
      it 'calcula el coeficiente impositivo correctamente' do
        expect(auto.coeficiente_impositivo).to eq(2)
      end
    end
  end

  describe '#valor_mercado' do
    it 'calcula el valor de mercado correctamente para 1000cc y 1000km' do
      expect(auto.valor_mercado).to eq(500.0)
    end

    it 'calcula el valor de mercado correctamente para 1600cc y 1000km' do
      auto = described_class.new(1600, 1000)
      expect(auto.valor_mercado).to eq(500.0)
    end
  end
end