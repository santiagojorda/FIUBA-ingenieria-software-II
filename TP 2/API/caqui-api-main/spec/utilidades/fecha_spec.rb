require 'integration_helper'

describe Fecha do
  describe '#initialize' do
    it 'crea una instancia de Fecha desde un String en formato DD/MM/YYYY' do
      fecha_str = '25/12/2025'
      fecha = described_class.new(fecha_str)
      expect(fecha.fecha).to eq(Date.new(2025, 12, 25))
    end

    it 'crea una instancia de Fecha desde un objeto Date' do
      date = Date.new(2023, 10, 15)
      fecha_obj = described_class.new(date)
      expect(fecha_obj.fecha).to eq(date)
    end

    it 'crea una instancia de Fecha desde un objeto DateTime' do
      datetime = DateTime.new(2023, 8, 5, 10, 30, 0)
      fecha_obj = described_class.new(datetime)
      expect(fecha_obj.to_s).to eq(datetime.strftime('%d/%m/%Y'))
    end

    it 'crea una instancia de Fecha desde un objeto FechaHorario' do
      fechahora = FechaHorario.new('05/08/2023 10:30')
      fecha_obj = described_class.new(fechahora)
      expect(fecha_obj.fecha.to_s).to eq(fechahora.to_date.to_s)
    end

    it 'lanza ArgumentError para tipos de entrada inválidos' do
      expect { described_class.new(123) }.to raise_error(ArgumentError, 'Formato inválido para fecha')
      expect { described_class.new(nil) }.to raise_error(ArgumentError, 'Formato inválido para fecha')
    end

    it 'lanza Date::Error para strings de fecha con formato incorrecto' do
      expect { described_class.new('2023-12-25') }.to raise_error(Date::Error)
    end

    it 'lanza Date::Error para strings de fecha invalidos (ej. 30 de febrero)' do
      expect { described_class.new('30/02/2023') }.to raise_error(Date::Error)
    end
  end

  describe '#to_s' do
    it 'devuelve la fecha como un string en formato DD/MM/YYYY' do
      fecha_obj = described_class.new(Date.new(2023, 7, 1))
      expect(fecha_obj.to_s).to eq('01/07/2023')
    end

    it 'maneja correctamente los días y meses de un solo dígito' do
      fecha_obj = described_class.new('05/03/2024')
      expect(fecha_obj.to_s).to eq('05/03/2024')
    end
  end

  describe '#<=>' do
    let(:fecha1) { described_class.new('10/10/2023') }
    let(:fecha2) { described_class.new('15/10/2023') }
    let(:fecha3) { described_class.new('10/10/2023') }

    it 'devuelve 0 cuando las fechas son iguales' do
      expect(fecha1 == fecha3).to eq(true)
    end

    it 'devuelve false cuando la primera fecha es menor que la segunda' do
      expect(fecha1 < fecha2).to eq(true)
    end

    it 'devuelve true cuando la primera fecha es mayor que la segunda' do
      expect(fecha2 > fecha1).to eq(true)
    end

    it 'devuelve nil cuando se compara con un objeto que no es Fecha' do
      expect(fecha1 <=> '10/10/2023').to be_nil
      expect(fecha1 <=> Date.new(2023, 10, 10)).to be_nil
      expect(fecha1 <=> nil).to be_nil
    end
  end

  describe 'getters' do
    it 'devuelve el año de la fecha' do
      fecha_obj = described_class.new('20/05/2024')
      expect(fecha_obj.anio).to eq(2024)
    end

    it 'devuelve el mes de la fecha' do
      fecha_obj = described_class.new('20/05/2024')
      expect(fecha_obj.mes).to eq(5)
    end

    it 'devuelve el día de la fecha' do
      fecha_obj = described_class.new('20/05/2024')
      expect(fecha_obj.dia).to eq(20)
    end
  end

  describe 'Comparable' do
    it 'compara fechas con < y >' do
      fecha_menor = described_class.new('01/01/2023')
      fecha_mayor = described_class.new('01/01/2024')

      expect(fecha_menor < fecha_mayor).to be true
      expect(fecha_mayor > fecha_menor).to be true
    end

    it 'compara igualdad de fechas' do
      fecha = described_class.new('01/01/2023')
      misma_fecha = described_class.new('01/01/2023')
      otra_fecha = described_class.new('01/01/2024')

      expect(fecha == misma_fecha).to be true
      expect(fecha != otra_fecha).to be true
    end

    describe '#<=>' do
      it 'devuelve nil si no es FechaHorario' do
        fh = described_class.new('01/01/2023 10:00')
        expect(fh <=> 'algo').to be_nil
      end

      it 'devuelve valor negativo si es menor' do
        fh_menor = described_class.new('01/01/2023 10:00')
        fh_mayor = described_class.new('01/01/2023 12:00')

        expect((fh_menor <=> fh_mayor)).to eq(0)
      end

      it 'devuelve valor positivo si es mayor' do
        fh_mayor = described_class.new('01/01/2023 12:00')
        fh_menor = described_class.new('01/01/2023 10:00')

        expect((fh_mayor <=> fh_menor)).to eq(0)
      end

      it 'devuelve 0 si son iguales' do
        fh1 = described_class.new('01/01/2023 10:00')
        fh2 = described_class.new('01/01/2023 10:00')

        expect((fh1 <=> fh2)).to eq(0)
      end
    end
  end

  describe '#es_fin_de_semana?' do
    it 'devuelve true si la fecha es sábado o domingo' do
      fecha_sabado = described_class.new('14/06/2025')
      expect(fecha_sabado.es_fin_de_semana?).to be true

      fecha_domingo = described_class.new('15/06/2025')
      expect(fecha_domingo.es_fin_de_semana?).to be true
    end

    it 'devuelve false si la fecha no fin de semana' do
      fecha_viernes = described_class.new('13/06/2025')
      expect(fecha_viernes.es_fin_de_semana?).to be false

      fecha_lunes = described_class.new('16/06/2025')
      expect(fecha_lunes.es_fin_de_semana?).to be false
    end
  end

  describe 'Calculos' do
    let(:fecha) { described_class.new('16/06/2025') }

    describe 'sumar dias #+' do
      it 'suma un Integer' do
        expect((fecha + 5).to_s).to eq('21/06/2025')
      end

      it 'lanza error si no es número' do
        expect do
          fecha + 0.5
        end.to raise_error(ArgumentError)
      end
    end

    describe 'restar dias #-' do
      it 'resta un Integer' do
        expect((fecha - 3).fecha).to eq(Date.new(2025, 6, 13))
      end

      it 'lanza error si no es número' do
        expect do
          fecha - 'asd'
        end.to raise_error(ArgumentError)
      end
    end
  end
end
