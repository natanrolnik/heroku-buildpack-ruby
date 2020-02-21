#   ruby_version = LanguagePack::RubyVersion.new("ruby-2.2.5")
#   outdated = LanguagePack::Helpers::DownloadPresence.new(
#     path: ruby_version,
#     stacks: ["cedar-14", "heroku-16", "heroku-18"]
#     fetcher: LanguagePack::Fetcher.new(LanguagePack::Base::VENDOR_URL, "heroku-16")
#   )
#
#   outdated.call
#   puts outdated.suggested_ruby_minor_version
#   #=> "ruby-2.2.10"
class LanguagePack::Helpers::DownloadPresence
  STACKS = ['cedar-14', 'heroku-16', 'heroku-18']

  def initialize(path, stacks: STACKS)
    @path = path
    @stacks = stacks
    @fetchers = []
    @threads = []
    @stacks.each do |stack|
      @fetchers << LanguagePack::Fetcher.new(LanguagePack::Base::VENDOR_URL, stack)
    end
  end

  def on_stack_list
    raise "not invoked yet, use the `call` method first" if @threads.empty?

    @threads.map.with_index do |thread, i|
      @stacks[i] if thread.value
    end.compact
  end

  def exists?
    raise "not invoked yet, use the `call` method first" if @threads.empty?
    join

    @threads.any? {|t| t.value }
  end

  def call
    @fetchers.map do |fetcher|
      @threads << Thread.new do
        fetcher.exists?(@path)
      end
    end
  end
end
