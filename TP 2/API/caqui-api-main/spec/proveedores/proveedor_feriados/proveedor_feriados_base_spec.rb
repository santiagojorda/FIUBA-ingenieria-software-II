require 'integration_helper'

describe ProveedorFeriadosBase do
  let(:proveedor) { described_class.new }
  let(:fecha) { Fecha.new('25/05/2025') }
  let(:fecha_horario) { FechaHorario.new('25/05/2025 00:00') }

  before(:each) do
    proveedor.instance_variable_set(:@feriados, [fecha])
  end

  describe '#es_feriado?' do
    describe 'cuando la fecha es un objeto Fecha' do
      it 'devuelve true si la fecha está en la lista de feriados' do
        expect(proveedor.es_feriado?(fecha)).to be true
      end

      it 'devuelve false si la fecha no está en la lista de feriados' do
        fecha_no_feriado = Fecha.new('01/01/2025')
        expect(proveedor.es_feriado?(fecha_no_feriado)).to be false
      end
    end

    describe 'cuando el objeto no es Fecha ni FechaHorario' do
      it 'devuelve error si no es un objeto Fecha' do
        expect do
          proveedor.es_feriado?('cadena cualquiera')
        end.to raise_error(ArgumentError)
      end
    end
  end
end
