RSpec.describe Sistema do
  let(:repo_pacientes_mock) { instance_double(RepositorioPacientes) }
  let(:repo_especialidades_mock) { instance_double(RepositorioEspecialidades) }
  let(:repo_medicos_mock) { instance_double(RepositorioMedicos) }
  let(:repo_turnos_mock) { instance_double(RepositorioTurnos) }
  let(:proveedor_fecha_real) { instance_double(ProveedorFechaReal) }
  let(:proveedor_feriados) { instance_double(ProveedorFeriadosNoLaborables) }
  let(:repositorio_reputaciones_mock) { instance_double(RepositorioReputaciones) }
  let(:gestor_pacientes_mock) { instance_double(GestorPacientes) }
  let(:gestor_especialidades_mock) { instance_double(GestorEspecialidades) }
  let(:gestor_medicos_mock) { instance_double(GestorMedicos) }

  def builder_de_sistema_correctamenete
    Sistema::Builder.new
                    .con_repositorio_pacientes(repo_pacientes_mock)
                    .con_repositorio_especialidades(repo_especialidades_mock)
                    .con_repositorio_medicos(repo_medicos_mock)
                    .con_repositorio_turnos(repo_turnos_mock)
                    .con_proveedor_fecha(proveedor_fecha_real)
                    .con_proveedor_feriados(proveedor_feriados)
                    .con_repositorio_reputaciones(repositorio_reputaciones_mock)
  end

  def builder_de_sistema_sin_repos
    Sistema::Builder.new
                    .con_proveedor_fecha(proveedor_fecha_real)
  end

  def builder_de_sistema_sin_proveedor_fecha
    Sistema::Builder.new
                    .con_repositorio_pacientes(repo_pacientes_mock)
                    .con_repositorio_especialidades(repo_especialidades_mock)
                    .con_repositorio_medicos(repo_medicos_mock)
                    .con_repositorio_turnos(repo_turnos_mock)
                    .con_proveedor_feriados(proveedor_fecha_real)
                    .con_repositorio_reputaciones(repositorio_reputaciones_mock)
  end

  def builder_de_sistema_sin_proveedor_feriados
    Sistema::Builder.new
                    .con_repositorio_pacientes(repo_pacientes_mock)
                    .con_repositorio_especialidades(repo_especialidades_mock)
                    .con_repositorio_medicos(repo_medicos_mock)
                    .con_repositorio_turnos(repo_turnos_mock)
                    .con_proveedor_fecha(proveedor_fecha_real)
                    .con_repositorio_reputaciones(repositorio_reputaciones_mock)
  end

  describe 'Sistema::Builder' do
    it 'levanta un error si faltan repositorios al construir' do
      builder = builder_de_sistema_sin_repos
      expect { builder.build }.to raise_error(ArgumentError, 'Faltan uno o más repositorios para construir el Sistema.')
    end

    it 'levanta un error si falta proveedor de fecha' do
      builder = builder_de_sistema_sin_proveedor_fecha
      expect { builder.build }.to raise_error(ArgumentError, 'Falta un proveedor de fecha para construir el Sistema.')
    end

    it 'levanta un error si falta proveedor de feriados' do
      builder = builder_de_sistema_sin_proveedor_feriados
      expect { builder.build }.to raise_error(ArgumentError, 'Falta un proveedor de feriados para construir el Sistema.')
    end

    it 'crea un gestor de pacientes automáticamente' do
      sistema = builder_de_sistema_correctamenete.build
      gestor = sistema.instance_variable_get(:@gestor_pacientes)

      expect(gestor).to be_an_instance_of(GestorPacientes)
      expect(gestor.instance_variable_get(:@repositorio_pacientes)).to eq(repo_pacientes_mock)
    end

    it 'crea un gestor de especialidades automáticamente' do
      sistema = builder_de_sistema_correctamenete.build
      gestor = sistema.instance_variable_get(:@gestor_especialidades)
      expect(gestor).to be_an_instance_of(GestorEspecialidades)
      expect(gestor.instance_variable_get(:@repositorio_especialidades)).to eq(repo_especialidades_mock)
    end

    it 'crea un gestor de medicos automáticamente' do
      sistema = builder_de_sistema_correctamenete.build
      gestor = sistema.instance_variable_get(:@gestor_medicos)
      expect(gestor).to be_an_instance_of(GestorMedicos)
      expect(gestor.instance_variable_get(:@repositorio_medicos)).to eq(repo_medicos_mock)
      expect(gestor.instance_variable_get(:@repositorio_especialidades)).to eq(repo_especialidades_mock)
    end

    it 'crea un gestor de turnos automáticamente' do
      sistema = builder_de_sistema_correctamenete.build
      gestor = sistema.instance_variable_get(:@gestor_turnos)
      expect(gestor).to be_an_instance_of(GestorTurnos)
      expect(gestor.instance_variable_get(:@repositorio_turnos)).to eq(repo_turnos_mock)
      expect(gestor.instance_variable_get(:@repositorio_medicos)).to eq(repo_medicos_mock)
    end

    it 'construye una instancia de Sistema correctamente con todos los repositorios' do
      sistema = builder_de_sistema_correctamenete.build
      expect(sistema).to be_an_instance_of(described_class)

      variables_esperadas = {
        :@repositorio_pacientes => repo_pacientes_mock,
        :@repositorio_especialidades => repo_especialidades_mock,
        :@repositorio_medicos => repo_medicos_mock,
        :@repositorio_turnos => repo_turnos_mock,
        :@proveedor_fecha => proveedor_fecha_real,
        :@proveedor_feriados => proveedor_feriados,
        :@repositorio_reputaciones => repositorio_reputaciones_mock
      }

      variables_esperadas.each do |variable, valor_esperado|
        expect(sistema.instance_variable_get(variable)).to eq(valor_esperado)
      end
    end
  end
end
