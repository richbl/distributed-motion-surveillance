#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'mail'

# -----------------------------------------------------------------------------
# email library
#
module LibMail
  # ---------------------------------------------------------------------------
  # SMTP implementation using the ruby mail library
  #
  class SMTP
    def initialize
      @mail = Mail.new
    end

    # -------------------------------------------------------------------------
    # SMTP implementation using the ruby mail library
    #
    def delivery_options(address, port, domain, user_name, password,
                         authentication, enable_starttls_auto)
      @mail.delivery_method :smtp, address: address,
                                   port: port,
                                   domain: domain,
                                   user_name: user_name,
                                   password: password,
                                   authentication: authentication,
                                   enable_starttls_auto: enable_starttls_auto
    end

    # -------------------------------------------------------------------------
    # simple SMTP implementation using the ruby mail library
    #
    def header(to, from, subject)
      @mail[:to] = to
      @mail[:from] = from
      @mail[:subject] = subject
    end

    # -------------------------------------------------------------------------
    # assign body property
    #
    def body(body)
      @mail[:body] = body
    end

    # -------------------------------------------------------------------------
    # assign file property
    #
    def attach_file(file)
      @mail.add_file(file)
    end

    # -------------------------------------------------------------------------
    # send the email
    #
    def send_mail
      @mail.deliver!
    end
  end
end
