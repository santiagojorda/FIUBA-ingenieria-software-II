require 'spec_helper'

describe 'App cli' do

  describe 'Entrada invalidas' do
    it 'sin entrada muestra error' do
      resultado = `ruby app.rb`
      expect(resultado.strip).to eq 'error: entrada requerida'
    end

    it 'formato entrada invalido' do
      resultado = `ruby app.rb auto/1000`
      expect(resultado.strip).to eq 'error: formato de entrada invalido: <tipo>/<cilindrada>/<kilometros>'
    end
  end

  describe 'Errores' do
    it 'tipo de vehiculo invalido' do
      resultado = `ruby app.rb bicicleta/1000/1000`
      expect(resultado.strip).to eq 'error: Tipo de vehiculo invalido'
    end

    it 'tipo de cilindrada invalida' do
      resultado = `ruby app.rb auto/100/1000`
      expect(resultado.strip).to eq 'error: Tipo de cilindrada invalida [1000, 1600, 2000]'
    end
  end

  describe 'Cotizaciones' do
    describe 'Autos' do
      it 'cilindrada=1000 y km=1000' do
        resultado = `ruby app.rb auto/1000/1000`
        expect(resultado.strip).to eq 'ci:1 & vm:500.0'
      end

      it 'cilindrada=1600 y km=1000' do
        resultado = `ruby app.rb auto/1600/1000`
        expect(resultado.strip).to eq 'ci:1 & vm:500.0'
      end
    end
  
    describe 'Camionetas' do
      it 'cilindrada=1000 y km=1000' do
        resultado = `ruby app.rb camioneta/1000/1000`
        expect(resultado.strip).to eq 'ci:1 & vm:750.0'
      end

      it 'cilindrada=1600 y km=1000' do
        resultado = `ruby app.rb camioneta/1600/1000`
        expect(resultado.strip).to eq 'ci:2 & vm:1153.8'
      end
    end

    describe 'Camiones' do
      it 'cilindrada=1000 y km=1000' do
        resultado = `ruby app.rb camion/1000/1000`
        expect(resultado.strip).to eq 'ci:2 & vm:1000.0'
      end

      it 'cilindrada=1600 y km=1000' do
        resultado = `ruby app.rb camion/1600/1000`
        expect(resultado.strip).to eq 'ci:3 & vm:1153.8'
      end
    end
  end
end
