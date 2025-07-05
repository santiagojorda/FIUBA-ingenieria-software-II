require 'integration_helper'

RSpec.describe ProveedorFechaReal do
  it 'al llamar a #hoy devuelve la fecha de hoy' do
    proveedor = described_class.new

    ahora = DateTime.now.new_offset('-03:00')
    esperado = FechaHorario.new(ahora)

    esperado_trunc = esperado.to_datetime.strftime('%d/%m/%Y %H:%M')
    actual_trunc = proveedor.ahora.to_datetime.strftime('%d/%m/%Y %H:%M')
    expect(actual_trunc).to eq(esperado_trunc)
  end
end
