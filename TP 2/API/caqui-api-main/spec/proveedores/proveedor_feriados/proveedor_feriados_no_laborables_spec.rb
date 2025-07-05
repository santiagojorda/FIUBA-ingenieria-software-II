require 'integration_helper'
require 'webmock/rspec'

RSpec.describe ProveedorFeriadosNoLaborables do
  describe 'Inicializar' do
    def stub_feriado(feriados = [], _anio, status_code)
      stub_request(:get, %r{#{Regexp.escape(described_class::URL_API)}/\d{4}})
        .to_return(status: status_code, body: feriados.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'devuelve la lista de feriados del año' do
      stub_feriado([{ 'motivo' => 'Día del Trabajador', 'dia' => 1, 'mes' => 5 }], 2025, 200)
      proveedor = described_class.new(2025)
      expect(proveedor.feriados).to be_an(Array)
      expect(proveedor.feriados.first.to_s).to eq('01/05/2025')
    end

    it 'lanza error si la API falla' do
      stub_feriado({}, 2025, 500)
      expect do
        described_class.new(2025)
      end.to raise_error(DataProviderError)
    end
  end
end
