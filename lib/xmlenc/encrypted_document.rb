module Xmlenc
  class EncryptedDocument
    attr_accessor :xml

    def initialize(xml)
      @xml = xml
    end

    def document
      @document = Nokogiri::XML::Document.parse(xml)
    end

    def encrypted_keys
      document.xpath('//xenc:EncryptedKey', NAMESPACES).collect { |n| EncryptedKey.new(n) }
    end

    def decrypt(key)
      encrypted_keys.each do |encrypted_key|
        encrypted_data = encrypted_key.encrypted_data

        data_key       = encrypted_key.decrypt(key)
        decrypted_data = encrypted_data.decrypt(data_key)
        encrypted_data.node.replace(decrypted_data)
      end
      @document.to_xml
    end
  end
end