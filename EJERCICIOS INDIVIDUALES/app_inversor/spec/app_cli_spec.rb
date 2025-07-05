require 'spec_helper'

describe 'App cli' do

  it 'sin entrada muestra error' do
    resultado = `ruby app_cli.rb`
    expect(resultado.strip).to eq 'error: entrada requerida'
  end

  it 'inverso de MiCasaLinda es mIcASAlINDA' do
    resultado = `ruby app_cli.rb MiCasaLinda`
    expect(resultado.strip).to eq 'mIcASAlINDA'
  end

  it 'inverso con numeros es igual' do
    resultado = `ruby app_cli.rb 1111`
    expect(resultado.strip).to eq '1111'
  end

end
