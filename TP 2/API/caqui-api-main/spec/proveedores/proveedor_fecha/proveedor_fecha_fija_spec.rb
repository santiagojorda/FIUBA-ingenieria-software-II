require 'integration_helper'

RSpec.describe ProveedorFechaFija do
  it 'devuelve la fecha fija pasada en el constructor' do
    fecha = FechaHorario.new('01/05/2025 10:00')
    proveedor = described_class.new(fecha)
    expect(proveedor.ahora).to eq(fecha)
  end

  it 'levanta ArgumentError si no se pasa un Date' do
    expect do
      described_class.new('2023-05-01 05:00')
    end.to raise_error(ArgumentError, 'La fecha fija debe ser un objeto FechaHorario.')
  end
end
