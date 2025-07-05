require 'spec_helper'

describe FabricaVehiculos do
  let(:fabrica) { FabricaVehiculos.new }
  let(:cilindrada) { 1000 }
  let(:kilometros) { 1000 }

  describe '#crear_vehiculo' do
    context "auto" do
      it 'crea y devuelve una instancia de Auto' do
        vehiculo = fabrica.crear_vehiculo('auto', cilindrada, kilometros)
        expect(vehiculo).to be_an_instance_of(Auto)
        expect(vehiculo.cilindrada).to eq(cilindrada)
        expect(vehiculo.kilometros).to eq(kilometros)
      end
    end

    context "camioneta" do
      it 'crea y devuelve una instancia de Camioneta' do
        vehiculo = fabrica.crear_vehiculo('camioneta', cilindrada, kilometros)
        expect(vehiculo).to be_an_instance_of(Camioneta)
        expect(vehiculo.cilindrada).to eq(cilindrada)
        expect(vehiculo.kilometros).to eq(kilometros)
      end
    end

    context "camion" do
      it 'crea y devuelve una instancia de Camion' do
        vehiculo = fabrica.crear_vehiculo('camion', cilindrada, kilometros)
        expect(vehiculo).to be_an_instance_of(Camion)
        expect(vehiculo.cilindrada).to eq(cilindrada)
        expect(vehiculo.kilometros).to eq(kilometros)
      end
    end

    context 'cuando el tipo es inválido' do
      it 'lanza un error' do
        tipo_invalido = 'bicicleta'
        expect { fabrica.crear_vehiculo(tipo_invalido, cilindrada, kilometros) }.to raise_error(TipoDeVehiculoInvalidoError)
      end
    end
  end
end