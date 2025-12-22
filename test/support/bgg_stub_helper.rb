module BggStubHelper
  def stub_bgg(endpoint, query: {}, fixture:)
    xml_path = File.join(__dir__, "../fixtures", "#{fixture}.xml")
    xml = File.read(xml_path)

    stub_request(:get, "https://boardgamegeek.com/xmlapi2/#{endpoint}")
      .with(query: query.transform_values(&:to_s))
      .to_return(
        status: 200,
        headers: { "Content-Type" => "application/xml" },
        body: xml
      )
  end
end
