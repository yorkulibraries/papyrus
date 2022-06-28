#  app/lib/my_attribute_map_resolver
class SamlMapResolverYork < DeviseSamlAuthenticatable::DefaultAttributeMapResolver
  def attribute_map
    issuer = saml_response.issuers.first
    case issuer
    when 'idp_entity_id'
      {
        'urn:mace:dir:attribute-def:uid' => 'user_name',
        'urn:mace:dir:attribute-def:email' => 'email',
        'urn:mace:dir:attribute-def:name' => 'last_name',
        'urn:mace:dir:attribute-def:givenName' => 'name'
      }
    end
  end
end
