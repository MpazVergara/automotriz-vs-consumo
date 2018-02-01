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

get '/simulacion' do
  erb :simulacion_consumo
end

post '/simulacion' do
  params["rut"],params["dv"],params["renta"],params["montoCredito"]=["7","7","7",params["montoCredito"].gsub(/\./,'')]
  cons = BCI.consumo.simulate("1",params)
  erb :simulacion_consumo_bci, locals: {
    monto_credito_automtriz: separador_miles(params["valcuota"]),
    monto_credito_consumo: separador_miles(cons["montoCuota"])}
end
