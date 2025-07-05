require 'spec_helper'

describe ResultadoCotizacion do
  let(:coeficiente_impositivo) { 1 }
  let(:valor_mercado) { 500.0 }
  let(:resultado) { described_class.new(coeficiente_impositivo, valor_mercado) }

  describe '#initialize' do
    it 'asigna correctamente el coeficiente impositivo y el valor de mercado' do
      expect(resultado.coeficiente_impositivo).to eq(coeficiente_impositivo)
      expect(resultado.valor_mercado).to eq(valor_mercado)
    end
  end
end