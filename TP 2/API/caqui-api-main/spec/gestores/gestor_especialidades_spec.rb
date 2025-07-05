require 'integration_helper'
require_relative '../../gestores/gestor_especialidades'

describe GestorEspecialidades do
  let(:repositorio_especialidades) { RepositorioEspecialidades.new }
  let(:gestor) { described_class.new(repositorio_especialidades) }

  describe 'deberia poder crear una especialidad' do
    it 'deberia crear una especialidad con los datos correctos' do
      especialidad = gestor.crear_especialidad('neurologia', 15)
      expect(especialidad.nombre).to eq 'neurologia'
      expect(especialidad.tiempo_atencion).to eq 15
    end
  end

  describe 'deberia poder buscar una especialidad por nombre' do
    it 'deberia retornar la especialidad creada' do
      gestor.crear_especialidad('cardiologia', 30)
      especialidad = gestor.buscar_por_nombre('cardiologia')
      expect(especialidad.nombre).to eq 'cardiologia'
      expect(especialidad.tiempo_atencion).to eq 30
    end
  end
end
