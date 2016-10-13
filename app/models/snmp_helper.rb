class SnmpHelper

	def self.run(id)
		@device = Device.find(id)
		#--
		the_json = {}
		SNMP::Manager.open(:host => @device.ip, :community => @device.community) do |manager|

			vars = [
				"ipInReceives.0",
				"ipOutRequests.0",
				"tcpInSegs.0",
				"tcpOutSegs.0",
				"udpInDatagrams.0",
				"udpOutDatagrams.0",
				"icmpInMsgs.0",
				"icmpOutMsgs.0"
			]
			resp = manager.get(vars)
			resp.each_varbind do |var|
				the_json[var.name] = var.value.to_i
			end
			# --
			vars = [
				"sysDescr.0",
				"sysUpTime.0",
				"sysContact.0",
				"sysName.0",
				"sysLocation.0"
			]
			resp = manager.get(vars)
			the_json["config_table"] = {}
			resp.each_varbind do |var|
				the_json["config_table"][var.name] = var.value.to_s
			end
			# --
			vars = [
				"ifNumber.0"
			]
			resp = manager.get(vars)
			resp.each_varbind do |var|
				the_json[var.name] = var.value.to_i
			end
			vars = [
				"ifDescr",
				"ifType",
				"ifMtu",
				"ifSpeed",
				"ifOperStatus",
				"ifInOctets",
				"ifInErrors",
				"ifOutOctets",
				"ifOutErrors"
			]
			manager.walk(vars) do |row|
				row.each_with_index do |e,i|
					the_json[e.name] = (self.is_i? e.value) ? e.value.to_i : e.value.to_s
				end
			end
		end
		return the_json
	end
	def self.is_i?(s)
		return true if Float(s) rescue false
	end
end