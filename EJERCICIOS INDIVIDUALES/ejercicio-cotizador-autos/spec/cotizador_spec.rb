require 'spec_helper'

describe Cotizador do
  let(:cotizador) { described_class.new }
  let(:cilindrada) { 1000 }
  let(:kilometros) { 1000 }

  describe '#cotizar' do
    context 'cuando el tipo es auto' do
      it 'crea un Auto y devuelve la cotizacion' do
        resultado = cotizador.cotizar('auto', cilindrada, kilometros)
        expect(resultado).to be_a(ResultadoCotizacion)
        expect(resultado.coeficiente_impositivo).to eq(1)
        expect(resultado.valor_mercado).to eq(500.0)
      end
    end

    context 'cuando el tipo es camioneta' do
      it 'crea una Camioneta y devuelve la cotizacion' do
        resultado = cotizador.cotizar('camioneta', cilindrada, kilometros)
        expect(resultado).to be_a(ResultadoCotizacion)
        expect(resultado.coeficiente_impositivo).to eq(1)
        expect(resultado.valor_mercado).to eq(750.0)
      end
    end

    context 'cuando el tipo es camion' do
      it 'crea un Camion y devuelve la cotizacion' do
        resultado = cotizador.cotizar('camion', cilindrada, kilometros)
        expect(resultado).to be_a(ResultadoCotizacion)
        expect(resultado.coeficiente_impositivo).to eq(2)
        expect(resultado.valor_mercado).to eq(1000.0)
      end
    end
  end
end
