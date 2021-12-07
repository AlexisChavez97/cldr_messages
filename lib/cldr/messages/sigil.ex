defmodule Cldr.Message.Sigil do
	@moduledoc """
	Implements `sigil_m` nacro to canonicalize an
	ICU message.

	"""

	@doc """
	Implements sigil `~m` to canonicalize an
	ICU message.

	ICU messages allow for whitespace to be used to
	format the message for developer and translator readability.
	At the same time, `gettext` uses the message string
	as a key when resolving translations.

	Therefore a developer or translator that modifies
	the message for readability may unintentionally
	create a new message rather than replace the old one
	simply because the message strings don't match exactly.

	It is possible to use the `fuzzy` option to the task
	`mix gettext.extract` however this may not be the desired
	behaviour either.

	The sigil `~m` therefore introduces a way for the developer
	to ensure the message is in a canonical format during
	compilation and therefore both error check the message format
	and ensure the message is in a canonical form irrespective
	of developer formatting.

	"""
	defmacro sigil_m({:<<>>, _meta, [message]}, modifiers) when is_binary(message) do
		options = Cldr.Message.Sigil.options(modifiers)
		canonical_message = Cldr.Message.canonical_message!(message, options)

		quote do
			unquote(canonical_message)
		end
	end

	def options([pretty]) when pretty in [?p, ?P] do
		[pretty: true]
	end

	def options(_modifiers) do
		[]
	end
end