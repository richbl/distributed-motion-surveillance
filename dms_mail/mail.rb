#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'mail'
require 'time'
require 'pathname'

require_relative '../lib/lib_mail'

require_relative 'mail_config'
require_relative 'mail_logging'

# -----------------------------------------------------------------------------
# email methods
#
class DMSMail
  # ---------------------------------------------------------------------------
  # initialize and start logging
  #
  def self.initialize
    @mail = DMSMailLogging.new
    @mail.logging "BEGIN #{self.class}"
  end

  # ----------------------------------------------------------------------------
  # self.get_event_details(media_filename) creates the following event details
  # based on media_filename:
  #
  #   event_number - Motion-generated event number
  #   event_date - Motion-generated event datetime
  #
  # NOTE: this method assumes that media_filename follows the default Motion
  # file-naming convention of %v-%Y%m%d%H%M%S (for movies) or %v-%Y%m%d%H%M%S-%q
  # (for pictures), where:
  #
  #   %v - Motion-generated event number
  #   %Y%m%d%H%M%S - ISO 8601 date, with hours, minutes, seconds notion
  #   %q - frame number (value ignored)
  #
  def self.get_event_details(media_filename)
    event_number, t = File.basename(media_filename).split(/-/)
    datetime = Time.new(t[0..3], t[4..5], t[6..7], t[8..9], t[10..11],
                        t[12..13])

    event_date = datetime.strftime('%Y-%m-%d at %T')
    [event_number, event_date]
  end

  # ----------------------------------------------------------------------------
  # check args passed in
  #
  def self.check_args
    if ARGV.count != 3
      @mail.logging 'Missing arguments passed. Exiting.', 3
      exit 1
    end

    return if File.exist?(ARGV[1])
    @mail.logging 'Media filename argument (' + ARGV[1] + ') does '\
      'not exist. Exiting.', 3
    exit 1
  end

  # ----------------------------------------------------------------------------
  # self.parse_event creates an event by parsing the following command line
  # arguments passed in via the on_picture_save or the on_movie_end command:
  #
  #  ARGV[0] pixels detected
  #  ARGV[1] media filename
  #  ARGV[2] device (camera) number
  #
  def self.parse_event
    check_args

    # given media_filename, parse for event details
    event_number, event_date = get_event_details(ARGV[1])
    @mail.logging 'Arguments passed into routine are ' + ARGV.inspect

    event_details = { number: event_number, date: event_date, camera_number:
    ARGV[2], pixels_detected: ARGV[0] }
    event_media = { media: ARGV[1] }
    [event_details, event_media]
  end

  # ----------------------------------------------------------------------------
  # compose the mail.header object
  #
  def self.mail_header(mail, event_details)
    mail.header(DMSMailConfig::EMAIL_TO, DMSMailConfig::EMAIL_FROM,
                'Motion Detected on Camera #' + event_details[:camera_number] +
                ' at ' + event_details[:date])
  end

  # ----------------------------------------------------------------------------
  # compose the mail.delivery_options object
  #
  def self.mail_delivery_options(mail)
    mail.delivery_options(
      DMSMailConfig::SMTP_ADDRESS,
      DMSMailConfig::SMTP_PORT.to_i,
      DMSMailConfig::SMTP_DOMAIN,
      DMSMailConfig::SMTP_USERNAME,
      DMSMailConfig::SMTP_PASSWORD,
      DMSMailConfig::SMTP_AUTHENTICATION,
      DMSMailConfig::SMTP_ENABLE_STARTTLS_AUTO
    )
  end

  # ----------------------------------------------------------------------------
  # performs a replace of the email body with replacement_string
  #
  def self.create_email_body(event_details)
    replacement_string = {
      '!EVENT' => event_details[:number],
      '!PIXELS' => event_details[:pixels_detected],
      '!CAMERA' => event_details[:camera_number]
    }

    replacement_string.each do |k, v|
      DMSMailConfig::EMAIL_BODY.dup.sub!(k, v)
    end
  end

  # ----------------------------------------------------------------------------
  # self.generate_smtp_email(event_details, event_media) generates and mails an
  # smtp email
  #
  # see ruby gem mail documentation for mail management options
  #
  def self.generate_smtp_email(event_details, event_media)
    mail = LibMail::SMTP.new
    mail_delivery_options(mail)
    mail_header(mail, event_details)
    mail.attach_file(event_media[:media])
    mail.body(create_email_body(event_details))

    mail.send_mail

    @mail.logging 'Email sent to ' + DMSMailConfig::EMAIL_TO
  end

  # ----------------------------------------------------------------------------

  @mail = DMSMailLogging.new
  @mail.logging 'BEGIN DMSMail'

  event_details, event_media = parse_event
  generate_smtp_email(event_details, event_media)
end
