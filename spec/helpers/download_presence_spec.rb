require "spec_helper"

describe LanguagePack::Helpers::DownloadPresence do
  it "detects when a package is not present on higher stacks" do
    download = LanguagePack::Helpers::DownloadPresence.new(
      'ruby-1.9.3.tgz',
      stacks: ['cedar-14', 'heroku-16', 'heroku-18']
    )

    download.call

    expect(download.exists?).to eq(true)
    expect(download.exists_on_stacks).to eq(['cedar-14'])
  end

  it "detects when a package is present on two stacks but not a third" do
    download = LanguagePack::Helpers::DownloadPresence.new(
      'ruby-2.3.0.tgz',
      stacks: ['cedar-14', 'heroku-16', 'heroku-18']
    )

    download.call

    expect(download.exists?).to eq(true)
    expect(download.exists_on_stacks).to eq(['cedar-14', 'heroku-16'])
  end

  it "detects when a package does not exist" do
  download = LanguagePack::Helpers::DownloadPresence.new(
      'does-not-exist.tgz',
      stacks: ['cedar-14', 'heroku-16', 'heroku-18']
    )

    download.call

    expect(download.exists?).to eq(false)
    expect(download.exists_on_stacks).to eq([])
  end

  it "detects default ruby version" do
    download = LanguagePack::Helpers::DownloadPresence.new(
      "#{LanguagePack::RubyVersion::DEFAULT_VERSION}.tgz",
    )

    download.call

    expect(download.exists?).to eq(true)
    expect(download.exists_on_stacks).to include(LanguagePack::Helpers::DownloadPresence::STACKS.last)
  end
end
