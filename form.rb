require 'sinatra'
require 'bci'
require 'date'

def separador_miles(numero)
  numero = String(numero).gsub(/\./,"")
  numero = numero.reverse!.gsub(/(?=\d*\.?)(\d{3})/){$1+'.'}
  numero = numero.reverse!.gsub(/^[\.]/,"")
  return numero
end

BCI = Bci::Client.new({ key: ENV['BCI_API_KEY'] })

get '/' do
  "Hola mundo"
end

get '/simulacion' do
  erb :simulacion_consumo
end

post '/simulacion_BCI' do
  params["rut"],params["dv"],params["renta"],params["montoCredito"]=["77777777","7","200000",params["montoCredito"].gsub(/\./,'')]
  puts params
  cons = BCI.consumo.simulate("1",params)
  erb :simulacion_consumo_bci, :locals => {
    :amnt => separador_miles(params["valcuota"]),
    :cmnt => separador_miles(cons["montoCuota"])}
end
