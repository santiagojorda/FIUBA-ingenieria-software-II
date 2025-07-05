require 'integration_helper'

describe FechaHorario do
  let(:fecha_horario_str) { '05/08/2023 10:30' }
  let(:fecha_str) { '05/08/2023' }
  let(:datetime) { DateTime.new(2023, 8, 5, 10, 30, 0, '-03:00') }
  let(:fecha_horario) { described_class.new(datetime) }

  describe '#initialize' do
    describe 'con un String válido en formato dd/mm/YYYY HH:MM' do
      it 'crea una instancia correctamente' do
        fh = described_class.new(fecha_horario_str)
        expect(fh.to_datetime).to eq(datetime)
      end
    end

    describe 'con un objeto DateTime' do
      it 'crea una instancia correctamente' do
        fh = described_class.new(datetime)
        expect(fh.to_datetime).to eq(datetime)
      end
    end

    it 'convierte un Time a DateTime' do
      time = Time.new(2025, 6, 21, 14, 0)
      fh = described_class.new(time)
      expect(fh.to_datetime).to be_a(DateTime)
      expect(fh.to_s).to eq('21/06/2025 14:00')
    end

    describe 'con un String en formato inválido' do
      it 'lanza Date::Error si el formato del string no coincide con el esperado' do
        expect { described_class.new('2023-08-05 10:30') }.to raise_error(Date::Error)
        expect { described_class.new('05-08-2023 10:30:00') }.to raise_error(Date::Error)
      end

      it 'lanza Date::Error si la fecha/hora en el string es inválida (ej. 32 de agosto)' do
        expect { described_class.new('32/08/2023 10:30') }.to raise_error(Date::Error)
        expect { described_class.new('05/08/2023 25:30') }.to raise_error(Date::Error)
      end

      it 'lanza Date::Error si el string no es parseable como fecha/hora' do
        expect { described_class.new('esto no es una fecha') }.to raise_error(Date::Error)
      end
    end
  end

  describe '#to_s' do
    it 'devuelve la fecha_hora como un string en formato DD/MM/YYYY HH:MM' do
      fh = described_class.new(fecha_horario_str)
      expect(fh.to_s).to eq('05/08/2023 10:30')
    end

    it 'maneja correctamente los componentes de un solo dígito (ej. 01/02/2023 03:05)' do
      fh = described_class.new('01/02/2023 03:05')
      expect(fh.to_s).to eq('01/02/2023 03:05')
    end
  end

  describe '#to_fecha' do
    it 'devuelve un objeto Fecha con la parte de la fecha correcta' do
      fecha = fecha_horario.to_fecha
      expect(fecha).to be_a(Fecha)
      expect(fecha.to_s).to eq(fecha_str)
    end
  end

  describe '#to_date' do
    it 'devuelve un objeto Date con la parte de la fecha correcta a partir de un string' do
      fh = described_class.new(fecha_horario_str)
      expect(fh.to_date).to eq(Date.new(2023, 8, 5))
    end

    it 'devuelve un objeto Date con la parte de la fecha correcta a partir de un DateTime' do
      fh = described_class.new(datetime)
      expect(fh.to_date).to eq(Date.new(2023, 8, 5))
    end
  end

  describe 'comparaciones de FechaHorario' do
    let(:fh1_string) { described_class.new('05/08/2023 10:30') }
    let(:fh1_datetime) { described_class.new(DateTime.new(2023, 8, 5, 10, 30, 0, '-03:00')) }
    let(:fh2_futuro) { described_class.new('05/08/2023 11:00') }
    let(:fh3_pasado) { described_class.new('05/08/2023 10:00') }

    describe '== (igualdad)' do
      it 'devuelve 0 cuando las fecha y horas son iguales' do
        expect(fh1_string == fh1_datetime).to eq(true)
      end
    end

    describe '< (menor)' do
      it 'devuelve true si la primera es anterior a la segunda' do
        expect(fh1_string < fh2_futuro).to eq(true)
        expect(fh3_pasado < fh1_string).to eq(true)
      end
    end

    describe '> (mayor)' do
      it 'devuelve 1 si la primera es posterior a la segunda' do
        expect(fh2_futuro > fh1_string).to eq(true)
        expect(fh1_string > fh3_pasado).to eq(true)
      end
    end
  end

  describe 'Comparable (operadores)' do
    let(:fh_base) { described_class.new('10/10/2023 12:00') }
    let(:fh_base_igual) { described_class.new('10/10/2023 12:00') }
    let(:fh_futuro) { described_class.new('10/10/2023 12:01') }
    let(:fh_pasado) { described_class.new('10/10/2023 11:59') }

    it 'compara igualdad con == y !=' do
      expect(fh_base == fh_base_igual).to be true
      expect(fh_base != fh_futuro).to be true
    end

    it 'compara menor y menor o igual (<, <=)' do
      expect(fh_pasado < fh_base).to be true
      expect(fh_base <= fh_base_igual).to be true
    end

    it 'compara mayor y mayor o igual (>, >=)' do
      expect(fh_futuro > fh_base).to be true
      expect(fh_base >= fh_pasado).to be true
    end
  end

  describe '#diferencia_en_horas' do
    let(:fh1) { described_class.new('05/08/2023 10:30') }
    let(:fh2) { described_class.new('05/08/2023 12:30') }
    let(:fh3) { described_class.new('05/08/2023 08:30') }
    let(:fh4) { described_class.new('06/08/2023 08:30') }

    it 'devuelve la diferencia positiva en horas si el otro es mayor' do
      expect(fh1.diferencia_en_horas(fh2)).to eq(2.0)
    end

    it 'devuelve la diferencia negativa en horas si el otro es menor' do
      expect(fh1.diferencia_en_horas(fh3)).to eq(-2.0)
    end

    it 'diferencia entre dias diferentes' do
      expect(fh1.diferencia_en_horas(fh4)).to eq(22.0)
    end

    it 'lanza error si no es FechaHorario' do
      expect { fh1.diferencia_en_horas('2023-08-05') }.to raise_error(ArgumentError)
    end
  end
end
