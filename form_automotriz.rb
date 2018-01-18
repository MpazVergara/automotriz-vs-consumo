require 'sinatra'
require 'bci'
require 'date'

BCI = Bci::Client.new({ key: ENV['BCI_API_KEY'] })

get '/' do
  "Hola mundo"
end

get '/form' do
  form_tag do
    label_tag(:my_name, "My name is:")
    text_field_tag(:my_name)
    submit_tag("Process")
  end
end

get '/simulacion' do
  erb :automotriz
end

post '/simulacion_BCI' do
  params[:montoAuto]=Integer(params[:valcuota])*Integer(params[:cantidadCuotas])
  erb :simulacion_consumo
end

post '/simulacion_BCI_response' do
  params["rut"],params["dv"]=params["rut"].split("-")
  params.to_s
  cons = BCI.consumo.simulate("1",params)
  cons.to_s
  erb :simulacion_consumo_bci, :locals => {:consmonto => cons["montoCredito"], :consauto => params["montoAuto"]}
end