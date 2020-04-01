# Legendo OAI

An Open Archives Initiative provider service for the Legendo system.

Uses FW/1  [http://framework-one.github.io/](http://framework-one.github.io/) version 1.2

## Implementation

- Create a directory under directory `domains` for the intented domain.
  (www.mydomain.com -> domains/www_mydomain_com)
- Create an implementation for OAIGateway
- Under directory `metadataformats` create a file for each desired output 'flavour' with naming pattern `record.[flavour].cfm`
  (record.edm.cfm, record.oai_dc.cfm) 
- Update beans.xml.cfm to include your version of AOIGateway
- Follow the instructions in mappings.txt