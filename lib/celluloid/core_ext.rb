require 'celluloid/fiber'

# Monkeypatch Thread to allow lazy access to its Celluloid::Mailbox
class Thread
  attr_accessor :uuid_counter, :uuid_limit

  # Retrieve the mailbox for the current thread or lazily initialize it
  def self.mailbox
    current[:mailbox] ||= Celluloid::Mailbox.new
  end

  # Receive a message either as an actor or through the local mailbox
  def self.receive(&block)
    if Celluloid.actor?
      Celluloid.receive(&block)
    else
      mailbox.receive(&block)
    end
  end
end

class Fiber
  # Celluloid::Task associated with this Fiber
  attr_accessor :task
end
