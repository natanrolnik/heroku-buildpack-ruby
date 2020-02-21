require "spec_helper"

describe LanguagePack::Helpers::DownloadPresence do
  it "detects 1.9.3 on cedar-14" do
    download = LanguagePack::Helpers::DownloadPresence.new(
      'ruby-1.9.3.tgz',
      stacks: ['cedar-14', 'heroku-16', 'heroku-18']
    )

    download.call
    expect(download.exists?).to eq(true)
    expect(download.exists_on_stacks).to eq(['cedar-14'])
  end
end
