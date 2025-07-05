require 'spec_helper'
require_relative '../app/generador_botones'
require 'telegram/bot'

describe 'botones en fila' do
  it 'genera un markup con botones correctos' do
    textos = ['Botón 1', 'Botón 2']
    callbacks = %w[accion_1 accion_2]

    generador = GeneradorDeBotones.new(textos, callbacks)
    markup = generador.markup

    expect(markup).to be_a(Telegram::Bot::Types::InlineKeyboardMarkup)
    expect(markup.inline_keyboard.size).to eq(2)

    boton1 = markup.inline_keyboard[0][0]
    boton2 = markup.inline_keyboard[1][0]

    expect(boton1.text).to eq('Botón 1')
    expect(boton1.callback_data).to eq('accion_1')
    expect(boton2.text).to eq('Botón 2')
    expect(boton2.callback_data).to eq('accion_2')
  end
end
