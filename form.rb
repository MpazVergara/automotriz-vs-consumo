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
  params["Amnt"]=Integer(params[:valcuota].sub(/\./,''))*Integer(params[:cantidadCuotas].sub(/\./,''))
  params["rut"],params["dv"],params["renta"],params["montoCredito"]=["77777777","7","200000",params["montoCredito"].sub(/\./,'')]
  cons = BCI.consumo.simulate("1",params)
  comparacion=Integer(params["Amnt"]) - Integer(cons["montoCredito"])
  erb :simulacion_consumo_bci, :locals => { :comp => comparacion,
    :amnt => separador_miles(params["Amnt"]), :acae => String(params["ACAE"]).sub(/\./,','), :actc => params["Actc"],
    :cmnt => separador_miles(cons["montoCredito"]), :ccae => String(cons["montoCae"]).gsub(/\./,','), :cctc => separador_miles(cons["montoCtc"])}
end
