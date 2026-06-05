class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	skip_forgery_protection if: -> { request.format.json? }

	private

	def render_success(data: nil, message: nil, meta: nil, status: :ok)
		payload = {}
		payload[:message] = message if message.present?
		payload[:data] = data unless data.nil?
		payload[:meta] = meta if meta.present?

		render json: payload, status: status
	end

	def render_errors(errors, status: :unprocessable_entity)
		normalized_errors = Array(errors).flatten.compact.map(&:to_s)
		normalized_errors = [ "No se pudo procesar la solicitud" ] if normalized_errors.empty?

		render json: { errors: normalized_errors }, status: status
	end

	def render_not_found(resource_name = "Recurso")
		render_errors("#{resource_name} no encontrado", status: :not_found)
	end

	def parse_date_input(value)
		return value if value.is_a?(Date)

		date_string = value.to_s.strip
		return nil if date_string.blank?

		[ "%d-%m-%Y", "%d/%m/%Y", "%Y-%m-%d" ].each do |format|
			begin
				return Date.strptime(date_string, format)
			rescue ArgumentError
				next
			end
		end

		nil
	end
end
