require 'sinatra'
require 'bci'
require 'date'

BCI = Bci::Client.new({ key: ENV['BCI_API_KEY'] })

get '/' do
  "Hola mundo"
end

get '/simulacion' do
  erb :simulacion_consumo
end

post '/simulacion_BCI' do
  params["Amnt"]=Integer(params[:valcuota])*Integer(params[:cantidadCuotas])
  params["rut"],params["dv"],params["renta"]=["77777777","7","200000"]
  params.to_s
  cons = BCI.consumo.simulate("1",params)
  print params["ACAE"]
  print cons
  cons.to_s
  erb :simulacion_consumo_bci, :locals => {
    :acae => params["ACAE"], :amnt => params["Amnt"], :actc => params["Actc"],
    :cmnt => cons["montoCredito"], :ccae => cons["montoCae"], :cctc => cons["montoCtc"]}
end
