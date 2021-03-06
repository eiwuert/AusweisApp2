Messages
--------
The AusweisApp2 (server) will send some proper
messages (**msg**) to your application (client)
during the whole workflow or as an answer to
your :doc:`commands`.




.. _access_rights:

ACCESS_RIGHTS
^^^^^^^^^^^^^
This message will be send by AusweisApp2 once the authentication is started
by :ref:`run_auth` and the AusweisApp2 got the certificate from the service.

If your application receives this message you can call :ref:`set_access_rights`
to change some optional access rights or you can call :ref:`get_access_rights`
to get this message again.

Also you can call :ref:`get_certificate` to get the certificate to show this
to your user.

The workflow will continue if you call :ref:`accept` to indicate that the
user accepted the requested access rights or call :ref:`cancel` to abort
the whole workflow.


  - **error**: This optional parameter indicates an error of a :ref:`set_access_rights` call
    if the command contained invalid data.

  - **raw**: Access rights of the service provider.

    - **effective**: Indicates the enabled access rights of **optional** and **required**.

    - **optional**: These rights are optional and can be enabled or disabled by :ref:`set_access_rights`.

    - **required**: These rights are mandatory and cannot be disabled.

.. code-block:: json

 {
   "msg": "ACCESS_RIGHTS",
   "error": "some optional error message",
   "raw":
         {
          "effective": [24,20,16,15,14,12,11,10,9,8,2,0],
          "optional": [15],
          "required": [24,20,16,14,12,11,10,9,8,2,0]
         }
 }


.. seealso::

  `TR-03110`_, part 4, chapter 2.2.3

.. _TR-03110: https://www.bsi.bund.de/EN/Publications/TechnicalGuidelines/TR03110/BSITR03110.html





.. _api_level:

API_LEVEL
^^^^^^^^^
This message will be send if :ref:`get_api_level` or :ref:`set_api_level` is called.

It lists all **available** API levels that can be used and set by :ref:`set_api_level`.
Also it indicates the **current** selected API level.

  - **error**: Optional error message if :ref:`SET_API_LEVEL` failed.

  - **available**: List of supported API level by this version.

  - **current**: Currently selected API level.

.. code-block:: json

  {
    "msg": "API_LEVEL",
    "error": "optional error message like an invalid level",
    "available": [1,2,3,4],
    "current": 4
  }

Your application should always set the compatible API level. The AusweisApp2
will support multiple API levels to give you enough time to add support
for the new API.

Even if you added support for the new API, your application should still support
the old API level in case the user updates your application but
does not update the AusweisApp2. Otherwise you need to show a message to the user
that they need to update the AusweisApp2.

The API level will be increased for **incompatible** changes only. If we can add
additional commands, messages or information without breaking the previous API
you can check the application version with :ref:`get_info` to know if the
current version supports your requirements.

This documentation will mark every API change with a flag like the following:

  - New in version 1.10.0.

  - Changed in version 1.10.0.

  - Deprecated since version 1.10.0.




.. _auth:

AUTH
^^^^
This message will be send by AusweisApp2 if an authentication
is initially started. The next message should be :ref:`access_rights`
or :ref:`auth` again if the authentication immediately results
in an error.

If you receive an :ref:`auth` message with a parameter **error**
your command :ref:`run_auth` was invalid and the workflow was not
started at all.


  - **error**: Optional error message if :ref:`run_auth` failed.

.. code-block:: json

  {
    "msg": "AUTH",
    "error": "error message if RUN_AUTH failed"
  }



If the workflow is finished the AusweisApp2 will send a message with
a result and an url parameter to indicate the end of an authentication.


  - **result**: The final result of authentication.

    - **major**: Major "error" code.

    - **minor**: Minor error code.

    - **language**: Language of description and message. AusweisApp2 will
      use "de" for German system locale or "en" as the fall back.

    - **description**: Description of the error message.

    - **message**: The error message.

  - **url**: Refresh url or communication error address.

.. code-block:: json

  {
    "msg": "AUTH",
    "result":
             {
              "major": "http://www.bsi.bund.de/ecard/api/1.1/resultmajor#ok"
             },
    "url": "https://test.governikus-eid.de/gov_autent/async?refID=_123456789"
  }


.. code-block:: json

  {
    "msg": "AUTH",
    "result":
             {
              "major": "http://www.bsi.bund.de/ecard/api/1.1/resultmajor#error",
              "minor": "http://www.bsi.bund.de/ecard/api/1.1/resultminor/al/common#internalError",
              "language": "en",
              "description": "An internal error has occurred during processing.",
              "message": "The ID card has been removed. The process is aborted."
             },
    "url": "https://test.governikus-eid.de/gov_autent/async?refID=_abcdefgh"
  }




.. _bad_state:

BAD_STATE
^^^^^^^^^
Indicates that your previous command was send in an invalid state.

Some commands can be send to the server only if certain "state"
is reached in the workflow to obtain the corresponding result.
Otherwise the command will fail with :ref:`bad_state`.

For example, you cannot send :ref:`get_certificate` if there is no
authentication in progress.


  - **error**: Name of the received command that is invalid in this state.

.. code-block:: json

  {
    "msg": "BAD_STATE",
    "error": "NAME_OF_YOUR_COMMAND"
  }




.. _certificate:

CERTIFICATE
^^^^^^^^^^^
Provides information about the used certificate.

  - **description**: Detailed description of the certificate.

    - **issuerName**: Name of the certificate issuer.

    - **issuerUrl**: URL of the certificate issuer.

    - **subjectName**: Name of the certificate subject.

    - **subjectUrl**: URL of the certificate subject.

    - **termsOfUsage**: Raw certificate information about
      the terms of usage.

  - **validity**: Validity dates of the certificate in UTC.

    - **effectiveDate**: Certificate is valid since this date.

    - **expirationDate**: Certificate is invalid after this date.

.. code-block:: json

  {
    "msg": "CERTIFICATE",
    "description":
                  {
                   "issuerName": "Governikus Test DVCA",
                   "issuerUrl": "http://www.governikus.de",
                   "subjectName": "Governikus GmbH & Co. KG",
                   "subjectUrl": "https://test.governikus-eid.de",
                   "termsOfUsage": "Anschrift:\t\r\nGovernikus GmbH & Co. KG\r\nAm Fallturm 9\r\n28359 Bremen\t\r\n\r\nE-Mail-Adresse:\thb@bos-bremen.de\t\r\n\r\nZweck des Auslesevorgangs:\tDemonstration des eID-Service\t\r\n\r\nZuständige Datenschutzaufsicht:\t\r\nDie Landesbeauftragte für Datenschutz und Informationsfreiheit der Freien Hansestadt Bremen\r\nArndtstraße 1\r\n27570 Bremerhaven"
                  },
    "validity":
               {
                "effectiveDate": "2016-07-31",
                "expirationDate": "2016-08-30"
               }
  }




.. _enter_can:

ENTER_CAN
^^^^^^^^^
Indicates that a CAN is required to continue workflow.

If the AusweisApp2 will send this message you need to
provide the CAN of inserted card with :ref:`set_can`.

The workflow will automatically continue if the CAN
was correct and the AuweisApp2 will send a :ref:`enter_pin` message.
If the correct CAN is entered the retryCounter will still be **1**.

If your application provides an invalid :ref:`set_can` command
the AusweisApp2 will send an :ref:`enter_can` message with an error
parameter.

If your application provides a valid :ref:`set_can` command
and the CAN was incorrect the AusweisApp2 will send :ref:`enter_can`
again but without an error parameter.


  - **error**: Optional error message if your command :ref:`set_can`
    was invalid.

  - **reader**: Information about the used card and card reader.
    Please see message :ref:`reader` for details.

.. code-block:: json

  {
    "msg": "ENTER_CAN",
    "error": "You must provide 6 digits",
    "reader":
             {
              "name": "NFC",
              "attached": true,
              "card":
                     {
                      "deactivated": false,
                      "retryCounter": 1
                     }
             }
  }




.. _enter_pin:

ENTER_PIN
^^^^^^^^^
Indicates that a PIN is required to continue the workflow.

If the AusweisApp2 sends this message, you will have to
provide the PIN of inserted card with :ref:`set_pin`.

The workflow will automatically continue if the PIN
was correct. Otherwise you will receive another message :ref:`enter_pin`.
If the correct PIN is entered the retryCounter will be set to **3**.

If your application provides an invalid :ref:`set_pin` command
the AusweisApp2 will send an :ref:`enter_pin` message with an error
parameter and the retryCounter of the card is **not**
decreased.

If your application provides a valid :ref:`set_pin` command
and the PIN was incorrect the AusweisApp2 will send :ref:`enter_pin`
again with a decreased retryCounter but without an error parameter.

If the value of retryCounter is **1** the AusweisApp2 will initially send an
:ref:`enter_can` message. Once your application provides a correct CAN the
AusweisApp2 will send an :ref:`enter_pin` again with a retryCounter of **1**.


  - **error**: Optional error message if your command :ref:`set_pin`
    was invalid.

  - **reader**: Information about the used card and card reader.
    Please see message :ref:`reader` for details.

.. code-block:: json

  {
    "msg": "ENTER_PIN",
    "error": "You must provide 6 digits",
    "reader":
             {
              "name": "NFC",
              "attached": true,
              "card":
                     {
                      "deactivated": false,
                      "retryCounter": 3
                     }
             }
  }




.. _enter_puk:

ENTER_PUK
^^^^^^^^^
Indicates that a PUK is required to continue the workflow.

If AusweisApp2 sends this message, you will have to
show a message to the user that the card is blocked
and needs to be unblocked by AusweisApp2.

You need to send a :ref:`cancel` to abort the workflow.


  - **reader**: Information about the used card and card reader.
    Please see message :ref:`reader` for details.

.. code-block:: json

  {
    "msg": "ENTER_PUK",
    "reader":
             {
              "name": "NFC",
              "attached": true,
              "card":
                     {
                      "deactivated": false,
                      "retryCounter": 0
                     }
             }
  }




.. _info:

INFO
^^^^
Provides information about the AusweisApp2.

Especially if you want to get a specific **Implementation-Version**
to check if the current installation supports some additional
:doc:`commands` or :doc:`messages`.

Also you should check the :ref:`api_level` as it will be
increased for **incompatible** changes.


  - **VersionInfo**: Structure of version information.

    - **Name**: Application name.

    - **Implementation-Title**: Title of implementation.

    - **Implementation-Vendor**: Vendor of implementation.

    - **Implementation-Version**: Version of implementation.

    - **Specification-Title**: Title of specification.

    - **Specification-Vendor**: Vendor of specification.

    - **Specification-Version**: Version of specification.

.. code-block:: json

  {
    "msg": "INFO",
    "VersionInfo":
                  {
                   "Name": "AusweisApp2",
                   "Implementation-Title": "AusweisApp2",
                   "Implementation-Vendor": "Governikus GmbH & Co. KG",
                   "Implementation-Version": "1.10.0",
                   "Specification-Title": "TR-03124",
                   "Specification-Vendor": "Federal Office for Information Security",
                   "Specification-Version": "1.2"
                  }
  }




.. _insert_card:

INSERT_CARD
^^^^^^^^^^^
Indicates that the AusweisApp2 requires a card to continue.

If the AusweisApp2 needs a card to continue the workflow
this message will be send as a notification.
If your application receives this message it should
show a hint to the user.

After the user inserted a card the workflow will automatically
continue, unless the eID functionality is disabled.
In this case, the workflow will be paused until another card is inserted.
If the user already inserted a card this message will not be sent at all.

This message will also be send if there is no connected card reader.


.. code-block:: json

  {"msg": "INSERT_CARD"}





INTERNAL_ERROR
^^^^^^^^^^^^^^
Indicates an internal error.

If your application receives this message you found
a bug. Please report this issue to our support!


  - **error**: Optional detailed error message.

.. code-block:: json

  {
    "msg": "INTERNAL_ERROR",
    "error": "Unexpected condition"
  }





INVALID
^^^^^^^
Indicates a broken JSON message.

If your application receives this message you
passed a broken JSON structure to the AusweisApp2.

Please fix your JSON document and send it again!


  - **error**: Detailed error message.

.. code-block:: json

  {
    "msg": "INVALID",
    "error": "unterminated string (offset: 12)"
  }





.. _reader:

READER
^^^^^^
Provides information about a connected or disconnected card reader.

This message will be send by the AusweisApp2 if a card reader was added
or removed to the operating system. Also if a card was inserted into a
card reader or removed from a card reader.

Your application can explicitly check for card reader with :ref:`get_reader`.

If a workflow is in progress and a card with disabled eID functionality was
inserted, this message will still be sent, but the workflow will be paused
until a card with enabled eID functionality is inserted.


  - **name**: Identifier of card reader.

  - **attached**: Indicates if a card reader is connected or disconnected.

  - **card**: Provides information about inserted card, otherwise null.

    - **deactivated**: True if eID functionality is deactivated, otherwise false.

    - **retryCounter**: Count of possible retries for the PIN. If you enter a PIN
      with command :ref:`set_pin` it will be decreased if PIN was incorrect.

.. code-block:: json

  {
    "msg": "READER",
    "name": "NFC",
    "attached": true,
    "card":
           {
            "deactivated": false,
            "retryCounter": 3
           }
  }




.. _reader_list:

READER_LIST
^^^^^^^^^^^
Provides information about all connected card readers.


  - **reader**: A list of all connected card readers. Please
    see message :ref:`reader` for details.

.. code-block:: json

  {
    "msg": "READER_LIST",
    "reader":
             [
               {
                "name": "Example reader 1 [SmartCard] (1234567) 01 00",
                "attached": true,
                "card": null
               },

               {
                "name": "NFC",
                "attached": true,
                "card":
                       {
                        "deactivated": false,
                        "retryCounter": 3
                       }
               }
             ]
  }




UNKNOWN_COMMAND
^^^^^^^^^^^^^^^
Indicates that the command type is unknown.

If your application receives this message you
passed a wrong command to the AusweisApp2.

Please fix your command and send it again!

Be aware of case sensitive names in :doc:`commands`.


  - **error**: Name of the unknown command.

.. code-block:: json

  {
    "msg": "UNKNOWN_COMMAND"
    "error": "get_INFo",
  }

