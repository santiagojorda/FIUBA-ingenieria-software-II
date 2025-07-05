require 'integration_helper'

describe ProveedorFeriadosMock do
  let(:fechas_feriados) { ['25/05/2025', '01/01/2025'] }
  let(:proveedor) { described_class.new(fechas_feriados) }

  describe '#initialize' do
    it 'carga las fechas pasadas como feriados' do
      expect(proveedor.feriados.map(&:to_s)).to include('25/05/2025', '01/01/2025')
    end

    it 'inicializa con feriados vacíos si no recibe fechas' do
      proveedor_vacio = described_class.new
      expect(proveedor_vacio.feriados).to be_empty
    end
  end

  describe '#es_feriado?' do
    it 'devuelve true para una fecha que está en feriados' do
      fecha = Fecha.new('25/05/2025')
      expect(proveedor.es_feriado?(fecha)).to be true
    end

    it 'devuelve false para una fecha que no está en feriados' do
      fecha = Fecha.new('02/02/2025')
      expect(proveedor.es_feriado?(fecha)).to be false
    end
  end
end
