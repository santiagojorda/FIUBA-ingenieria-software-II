require 'telegram/bot'

class GeneradorDeBotones
  def initialize(textos, callbacks)
    raise ArgumentError, 'Los vectores deben tener el mismo tamaño' unless textos.size == callbacks.size

    @textos = textos
    @callbacks = callbacks
  end

  def markup
    botones = @textos.zip(@callbacks).map do |texto, callback|
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: texto,
        callback_data: callback
      )
    end

    Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: botones.map { |b| [b] } # cada botón en una fila distinta
    )
  end
end
