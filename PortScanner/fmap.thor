require 'rubygems'
require 'socket'
require 'timeout'
require 'thor'

CONNECTED="Abierto"
CLOSED="Cerrado"
FILTERED="Filtrado"
WAIT_TIME=0.001

class Fmap < Thor

	class_option :a_port , :type => :numeric, :aliases => "-p" , :desc => "Escanea un puerto especifico (Ej: -p 80)"
	class_option :range , :type => :array, :aliases => "-r" , :desc => "Escanea un range de puertos (Ej: -r 1 999)"

##FUNCIONES
	no_tasks do
		# get_state: Retorna el estado de un puerto (Abierto, Cerrado o Filtrado)
		def get_state(port,ip,timeout)
			begin
				status = Timeout::timeout(timeout){

				begin
					socket = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
					socket.connect Socket.pack_sockaddr_in(port, ip)
					socket.shutdown
					socket.close
					return CONNECTED
				rescue  Errno::ECONNREFUSED
					return CLOSED
				end
				}

			rescue Timeout::Error
				return FILTERED
			rescue Exception=>e
				puts e.message
			end
		end

		#range: Retorna el estado de cada puerto dentro del rango
		def range (ip_adress,initial_port,final_port)
			open_ports = []
			closed_ports = []
			filtered_ports = []

			conected_list_index=0, closed_list_index=0, filtered_list_index=0
			#Agrego el nro de puerto en su lista correspondiente e incremento el indice
			#de la lista
			for port_number in initial_port..final_port
				status = get_state(port_number,ip_adress, WAIT_TIME)
				case status
			 		when  CONNECTED then open_ports[conected_list_index]=port_number
	 				  conected_list_index+=1
			 		when  CLOSED then closed_ports[closed_list_index]=port_number
	 					closed_list_index+=1
					when  FILTERED then filtered_ports[filtered_list_index]=port_number
	 					filtered_list_index+=1
				end
			end

			#Creo un array, cada elemento es un diccionario que contiene los puertos
			#con un estado asociado (String)
			array_of_ports =[
				{'status'=>"Abierto",'list_name'=>open_ports},
				{'status'=>"Cerrado", 'list_name' => closed_ports},
				{'status'=>"Filtrado", 'list_name'=>filtered_ports}]
			#Ordeno las listas, la que tenga mas cantidad de puertos va al principio
			ordered_array_of_ports= array_of_ports.sort_by { |ports_hash| -ports_hash[list_name].length}
			#Muestro la cantidad de puertos de la lista mas grande
			puts "#{ordered_array_of_ports[0].length} puertos #{ordered_array_of_ports[0]['status']}"
			#Muestro cada puerto de las demas listas
			see_details(ordered_array_of_ports[1]['list_name'],ordered_array_of_ports[1]['status'])
			see_details(ordered_array_of_ports[2]['list_name'],ordered_array_of_ports[2]['status'])

		end

		def see_details(port_list, status)
			port_list.each do |port|
				puts "Puerto #{port} #{status}"
			end
	  end

	end


##FUNCIONES DEL PARSER DE THOR
	desc "scan DIRECCION_IP", "Recibe una Direccion IP y obtiene status de los primeros 1000 puertos"

		def scan (ip_adress)
			a_port = options[:a_port]
			range = options[:range]
			if a_port and !range
				puts "Estado del puerto #{a_port} #{get_state(a_port, ip_adress, WAIT_TIME)}"
			else if range and !a_port
					range(ip_adress, range[0].to_i, range[1].to_i)
			else
				range(ip_adress,1,1000)
			end
		end
	end
end

Fmap.start
