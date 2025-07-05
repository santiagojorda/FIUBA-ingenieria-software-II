require 'spec_helper'

describe 'Inversor' do

  it 'inverso de hola es HOLA' do
    resultado = Inversor.new.invertir 'hola'
    expect(resultado).to eq 'HOLA'
  end

  it 'inverso de HOLA es hola' do
    resultado = Inversor.new.invertir 'HOLA'
    expect(resultado).to eq 'hola'
  end

  it 'inverso de hoLA es HOla' do
    resultado = Inversor.new.invertir 'hoLA'
    expect(resultado).to eq 'HOla'
  end

  it 'inverso de HOla es hoLA' do
    resultado = Inversor.new.invertir 'HOla'
    expect(resultado).to eq 'hoLA'
  end

  it 'inverso de uNo es UnO' do
    resultado = Inversor.new.invertir 'uNo'
    expect(resultado).to eq 'UnO'
  end

end
