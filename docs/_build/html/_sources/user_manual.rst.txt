.. sectnum::

User Manual
===========

The Insurance Management Information System (IMIS) is a web based software to manage health insurance schemes. It includes functionality for setup of the software to requirements of health insurance schemes, administration of policies and policy holders and for claim processing. This manual is a guide on the use and functionality of the software rather than in-depth technical reference. The Contents section, provide a reference to the page of each major chapter and the sub chapters within. By clicking on the content title (online version), the reader is re-directed to the position of the content title.

The following conventions are used:

  - `<Hyperlink>`_  enable a quick link (using the online version) to the subject relating to the functionality,
  - **Item** means an item in a drop down list,
  - ``LABEL`` means a data field or a button,
  - _NAME_OF_PAGE_ means a name of page or a data field in a text without hyperlink.

Users’ roles and rights
-----------------------

+-----------------------+-----------------------+-----------------------+
| Role                  | Responsibilities      | Available             |
|                       |                       | functionality         |
+=======================+=======================+=======================+
|     **Scheme          |                       |                       |
|     administrator &   |                       |                       |
|     district Staff**  |                       |                       |
+-----------------------+-----------------------+-----------------------+
|     Enrolment Officer |     He/she enrols     |     Capture a photo   |
|                       |     insurees and      |     of an Insuree     |
|                       |     submits enrolment |                       |
|                       |     forms to a health |     Send a photo      |
|                       |     insurance         |                       |
|                       |     administration;   |     Inquiry on an     |
|                       |     handles policy    |     Insuree           |
|                       |     modifications;    |                       |
|                       |     collects feedback |     Collect feedback  |
|                       |     from scheme       |     from an Insuree   |
|                       |     patients and      |                       |
|                       |     submits to the    |                       |
|                       |     health insurance  |                       |
|                       |     administration.   |                       |
+-----------------------+-----------------------+-----------------------+
|     Village Executive |     He/she collects   |     Collect feedback  |
|     Officer (VEO)     |     feedbacks and     |     from an Insuree   |
|                       |     collects changes  |                       |
|                       |     on insurees       |     Inquiry on an     |
|                       |     during insurance  |     Insuree           |
|                       |     periods           |                       |
+-----------------------+-----------------------+-----------------------+
|     Manager           |     Over-sees         |     Create managerial |
|                       |     operations of the |     statistics        |
|                       |     health insurance  |                       |
|                       |     scheme; runs IMIS |     Authorize         |
|                       |     operational       |     issuance of a     |
|                       |     reports analyses  |     substitution      |
|                       |     data generated    |     membership card   |
|                       |     from the IMIS.    |                       |
+-----------------------+-----------------------+-----------------------+
|     Accountant        |     Transfers data on |     Transfer of data  |
|                       |     collected         |     on Contributions  |
|                       |     Contributions to  |     to accounting     |
|                       |     an external       |     system            |
|                       |     accounting        |                       |
|                       |     system.           |     Valuation of a    |
|                       |     Calculates claim  |     claim             |
|                       |     amounts per       |                       |
|                       |     health facility,  |     Transfer of a     |
|                       |     runs IMIS         |     batch of claims   |
|                       |     operational       |     for payment       |
|                       |     reports and       |                       |
|                       |     presents claims   |                       |
|                       |     decision overview |                       |
|                       |     to management of  |                       |
|                       |     a health          |                       |
|                       |     insurance         |                       |
|                       |     administrator.    |                       |
|                       |     Processes         |                       |
|                       |     approved claims   |                       |
|                       |     to health         |                       |
|                       |     facility          |                       |
|                       |     sub-accounts.     |                       |
+-----------------------+-----------------------+-----------------------+
|     Clerk             |     Enters and        |     `Creation/Finding |
|                       |     modifies data on  | /Modification         |
|                       |     families,         |     /Deleting <#famil |
|                       |     insurees,         | y-overview-page.>`__  |
|                       |     policies and      |     of a              |
|                       |     contributions.    |     `Household-group  |
|                       |                       | <#familygroup-page>`_ |
|                       |     Enters data on    | _,                    |
|                       |     claims if the     |     an                |
|                       |     claims are        |     `Insure <#insuree |
|                       |     submitted in a    | -page>`__\ e,         |
|                       |     paper form        |     a                 |
|                       |                       |     `Policy <#policy- |
|                       |                       | page>`__              |
|                       |                       |     or a              |
|                       |                       |     `Contribution <#c |
|                       |                       | ontribution-page>`__. |
|                       |                       |                       |
|                       |                       |     `Renewal of a     |
|                       |                       |     policy <#policy-r |
|                       |                       | enewals>`__           |
|                       |                       |                       |
|                       |                       |     `Entry of a       |
|                       |                       |     claim <#changing- |
|                       |                       | of-users-password>`__ |
+-----------------------+-----------------------+-----------------------+
|     Medical Officer   |     Provides          |     Checking of a     |
|                       |     technical advice  |     claim for         |
|                       |     on claims         |     plausibility      |
|                       |     verification from |                       |
|                       |     a medical         |     Review of a claim |
|                       |     standpoint.       |                       |
|                       |                       |     Authorize a claim |
|                       |                       |     for payment       |
+-----------------------+-----------------------+-----------------------+
|     Scheme            |     Administers       |     `Administer       |
|     Administrator     |     registers (all    |     registers <#admin |
|                       |     except the        | istration-of-register |
|                       |     register of       | s>`__                 |
|                       |     users)            |     (`Officers <#heal |
|                       |                       | th-facilities-adminis |
|                       |                       | tration>`__,          |
|                       |                       |     `Payers <#health- |
|                       |                       | facilities-administra |
|                       |                       | tion>`__,             |
|                       |                       |     `Medical          |
|                       |                       |     Services <#medica |
|                       |                       | l-service-price-lists |
|                       |                       | -administration>`__,  |
|                       |                       |     `Medical          |
|                       |                       |     Items <#medical-s |
|                       |                       | ervice-price-lists-ad |
|                       |                       | ministration>`__,     |
|                       |                       |     `Health           |
|                       |                       |     Facilities <#heal |
|                       |                       | th-facilities-adminis |
|                       |                       | tration>`__,          |
|                       |                       |     `Medical Item     |
|                       |                       |     Price             |
|                       |                       |     Lists <#medical-s |
|                       |                       | ervice-price-lists-ad |
|                       |                       | ministration>`__,     |
|                       |                       |     `Medical Services |
|                       |                       |     Price             |
|                       |                       |     List, <#medical-s |
|                       |                       | ervice-price-lists-ad |
|                       |                       | ministration>`__      |
|                       |                       |     `Products <#claim |
|                       |                       | -administrators-admin |
|                       |                       | istration>`__),       |
|                       |                       |     `Extract Creation |
|                       |                       |     for Off-line      |
|                       |                       |     Health            |
|                       |                       |     Facilities <#imis |
|                       |                       | -extracts-online-mode |
|                       |                       | >`__                  |
+-----------------------+-----------------------+-----------------------+
|     IMIS              |     Administers       |     Administer the    |
|     Administrator     |     operations of the |     register of       |
|                       |     IMIS. Is          |     `users <#_User_Ad |
|                       |     responsible for   | ministration>`__      |
|                       |     backups of data.  |     (of the           |
|                       |                       |     IMIS),\ `Utilitie |
|                       |                       | s <#utilities>`__,    |
|                       |                       |     `Backup <#backup> |
|                       |                       | `__,                  |
|                       |                       |     `Restore <#restor |
|                       |                       | e>`__                 |
|                       |                       |     and               |
|                       |                       |     `Updates <#execut |
|                       |                       | e-script>`__,         |
|                       |                       |     `Extract Creation |
|                       |                       |     for Off-line      |
|                       |                       |     Health            |
|                       |                       |     Facilities <#imis |
|                       |                       | -extracts-online-mode |
|                       |                       | >`__                  |
+-----------------------+-----------------------+-----------------------+
|     **Health Facilities staff**                                       |
+-----------------------+-----------------------+-----------------------+
|     Receptionist      |     Verifies          |     Inquiring on a    |
|                       |     membership and    |     Household/group,  |
|                       |     issues to a       |     `Insuree <#find-i |
|                       |     patient a claim   | nsuree>`__            |
|                       |     form.             |     and               |
|                       |                       |     `Policy <#_Image_ |
|                       |                       | 4.16_(Find>`__        |
+-----------------------+-----------------------+-----------------------+
|     Claim             |     Pools claim forms |     Opening of a      |
|     administrator     |     of a health       |     batch of claims   |
|                       |     facility, enters  |                       |
|                       |     and submits       |     Entry of a claim  |
|                       |     claims.           |                       |
+-----------------------+-----------------------+-----------------------+
|     HF                |     Off-line Health   |     `Off-line extract |
|     Administrator     |     Facility          |     upload <#imis-ext |
|                       |     administration,   | racts-offline-mode>`_ |
|                       |     Off-line extract  | _                     |
|                       |     upload            |                       |
+-----------------------+-----------------------+-----------------------+
|     Offline           |     Creation of clerk |                       |
|     Administrator     |     user in the       |                       |
|                       |     offline IMIS,     |                       |
|                       |     Creation of       |                       |
|                       |     offline Extract   |                       |
+-----------------------+-----------------------+-----------------------+

Login Access
------------

To access the software, Users, must have a valid User Name and Password, provided by the “IMIS Administrator”. In the browser address bar type URL of the IMIS and request the start page. Login page will appear (:ref:`image1`).

.. _image1:
.. figure:: /img/user_manual/image1.png
  :align: center

  `Image 1 - User Login`

Use the provided Login Name and Password, and click on the button Login. If successful, the system will re-direct to the Home Page (:ref:`image2`).

.. _image2:
.. figure:: /img/user_manual/image2.png
  :align: center

  `Image 2 - Home Page`

The full menu is displayed; Clicking on the menu headers will display a sub-menu providing further navigation options. Menus with a blue fore-colour are accessible, while menus with a grey fore-colour are disabled; either due to access rights of a user or unavailable functionality. Below the main menu at the top left-hand corner there is information about the current login user: Login Name, a list of roles acquired by the user and the districts to which the user has access.

When a password is forgotten, clicking ``Forgot Password?`` results in the Forgot ``Password Page`` (:ref:`image3`).

.. _image3:
.. figure:: /img/user_manual/image3.png
  :align: center

  `Image 3 - Forgot Password Page`

Enter the ``Email`` linked to the account and click on the ``Submit`` button. In case the ``Email`` coincides with the e-mail address provided with the user in the register of users, the forgotten password is sent to the indicated e-mail.

Administration of registers
---------------------------

Registers of IMIS serve as a principal tool by which IMIS is adjusted to needs of health insurance schemes. With exception of the register of Users that can be managed only by users with the role IMIS Administrator, all other registers can be managed by users with the role Scheme Administrator.

The register of Users defines who can login to IMIS and under what constraints. The register of Locations defines administrative division of the territory, on which a health insurance scheme is operated. The register of Payers allows specification of institutional payers that can pay contributions on behalf of policy holders (households, groups of persons). The register of Enrolment Agents specifies all persons (either employed or contracted) by the scheme administration that are entitled to distribute/sell policies to population. The register of Claim Administrators specifies all employees of health facilities that are entitled to submit claims to the scheme administration. The register of Health Facilities contains all contractual health facilities that can submit claims to the scheme administration. The register of Medical Items specifies all possible medical items (drugs, prostheses, medical devices etc.) that can be used in definitions of packages of insurance products and in pricelists associated with contractual health facilities. The register of Pricelists that splits into two divisions for Medical Services and for Medical Items contains pricelists valid for individual health facilities or their groups reflecting results of price negotiations between contractual health facilities and the scheme administration. Finally, the register of Products includes definitions of all insurance products that can be distributed/ sold within the health insurance scheme.

Insurance Products Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register of insurance products contains all insurance products in the health insurance scheme. There may be several insurance products available for distribution/selling in a territory, e.g. one basic product and one or several supplemental insurance products. The insurance products may at the different levels. For example that basic insurance product may be at the national level whereas the supplemental insurance products may be at the regional level. Administration of the register of insurance products is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

An insurance product may only be added or thereafter edited, after the approval of the management of the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of insurance products can be found under the main menu ``Administration``, sub menu ``Products``.

.. _image4:
.. figure:: /img/user_manual/image4.png
  :align: center

  `Image 4 - Navigation Products`

Product Control Page
""""""""""""""""""""

Clicking on the sub menu ``Products`` re-directs the current user to the ``Product Control Page``.

.. _image5:
.. figure:: /img/user_manual/image5.png
  :align: center

  `Image 5 - Product Control Page`

The ``Product Control Page`` is the central point for administration of insurance products. By having access to this page, it is possible to add, edit, duplicate and search. The panel is divided into four panels. (:ref:`image5`)

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of Products the following search options are available, which can be used alone, or in combination with each other.

  -  ``Product Code``

    Type in the beginning of; or the full ``Product Code``; to search for products with a ``Product Code``, which starts with or matches completely, the typed text.

  -  ``Product Name``

    Type in the beginning of; or the full ``Product Name`` to search for products with a ``Product Name``, which starts with or matches completely, the typed text.

  -  ``Date From``

    Type in a date; or use the Date Selector Button, to search for products with a ``Date From``, which is on or is greater than the date typed/selected. *Note: To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

  -  ``Date To``

    Type in a date; or use the Date Selector Button, to search for products with a ``Date To``, which is on or is greater than the date typed/selected. *Note: To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

  -  ``Date Selector Button``

    Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image6`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

    -  Anytime during the use of the pop-up, the user can see the date of today.

    -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.

    -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.

    -  Clicking on the arrow to the left displays the previous month.

    -  Clicking on the arrow on the right will displays the following month.

    -  Clicking on the month will display all the months for the year.

    -  Clicking on the year will display a year selector.

    .. _image6:
    .. |logo1| image:: /img/user_manual/image6.png
      :scale: 100%
      :align: middle
    .. |logo2| image:: /img/user_manual/image7.png
      :scale: 100%
      :align: middle
    .. |logo3| image:: /img/user_manual/image8.png
      :scale: 100%
      :align: middle

    +---------+---------+---------+
    | |logo1| | |logo2| | |logo2| |
    +---------+---------+---------+
      `Image 6 - Calendar Selector - Search Panel`

  -  ``Region``

    Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select products from a specific region. The option **National** means that the found insurance products should be common for all regions. `Note: The list will only be filled with the regions assigned to the current logged in user and with the option National. All nationwide products and all regional products relating to the selected region will be found. If no district is selected then also all district products for districts belonging to the selected region will be found.`

  -  ``District``

    Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select products from a specific district. `Note: The list will be only filled with the districts belonging to the selected region. All nationwide products, all regional products relating to the selected region and all district products for the selected district will be found.`

  -  ``Historical``

    Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image7`).

  .. _image7:
  .. figure:: /img/user_manual/image9.png
    :align: center

    `Image 7 - Historical records - Result Panel`

  -  ``Search Button``

    Once the criteria have been entered, use the search button to filter the records, the results will appear in the result panel.

  B. Result Panel

  The result panel displays a list of all products found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image8`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image8:
  .. figure:: /img/user_manual/image10.png
   :align: center

   `Image 8 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image9`).

  .. _image9:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 9 - Page selector - Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the Home Page (:ref:`image2`), and the Add button which re-directs to the product page, the button panel (the buttons ``Edit`` and ``Duplicate`` ) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a product has been added, updated or deleted or if there was an error at any time during the process of these actions.

Product Page
""""""""""""

  **1. Data Entry**

  .. _image10:
  .. |logo4| image:: /img/user_manual/image12.png
    :scale: 100%
    :align: middle
  .. |logo5| image:: /img/user_manual/image13.png
    :scale: 100%
    :align: middle

  +---------+
  | |logo4| |
  +---------+
  | |logo5| |
  +---------+

    `Image 10 - Product Page`

    -  ``Product Code``

      Enter the product code for the product. Mandatory, 8 characters.

    -  ``Product Name``

      Enter product name for the product. Mandatory, 100 characters maximum.

    -  ``Region``

      Select the region in which the product will be used, from the list by clicking on the arrow on the right hand side of the lookup. The option National means that the insurance product is nationwide and it is not constraint to a specific region. `Note: The list will only be filled with the regions assigned to the current logged in user and with the option National.` Mandatory.

    -  ``District``

      Select the district in which the product will be used, from the list by clicking on the arrow on the right hand side of the lookup. `Note: The list will only be filled with the districts assigned to the selected region and assigned to the current logged in user. If no district is selected then the product is considered to be either nationwide (the option National is selected in the field Region) or regional associated with the selected region.`

    -  ``Date From``

      Type in the date or use the ``Date Selector Button`` to provide the date for which underwriting for the insurance product can be done from. ``Date From`` determines the earliest date from which underwriting can be done. `Note: To clear the date entry box; use the mouse to highlight the full date and then press the space key.` Mandatory.

    -  ``Date To``

      Type in the date or use the Date Selector Button to provide the date until which underwriting can be done to.`Note: To clear the date entry box; use the mouse to highlight the full date and then press the space key.` Mandatory.

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image11`). By default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted. At anytime during the use of the pop-up, the user can see the date of ``today``.

      -  Clicking on ``today`` will close the pop-up and display the today’s date in the corresponding date entry box.
      -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
      -  Clicking on the arrow to the left displays the previous month.
      -  Clicking on the arrow on the right will displays the following month.
      -  Clicking on the month will display all the months for the year.
      -  Clicking on the year will display a year selector.

      .. _image11:
      .. |logo6| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo7| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo8| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +---------+---------+---------+
      | |logo6| | |logo7| | |logo8| |
      +---------+---------+---------+

        `Image 11 - Calendar Selector - Search Panel`


    -  ``Conversion``

      Select from the list of products, a reference to the product which replaces the current product in case of renewal after the ``Date to``. `Note: Selecting the current product will prevent the record from saving, and cause a message to be displayed in the Information Panel.`

    -  ``Lump Sum``

      Enter the lump sum contribution (an amount paid irrespective of the number of members up to a threshold) to be paid by a household/group for the product. If the lump sum is zero no lump sum is applied irrespective of the threshold members. Decimal up to two digits.

    -  ``Threshold Members``

      Enter the threshold number of members in product for which the lump sum is valid.

    -  ``Number of Members``

      Enter the maximal number of members of a household/group for the product.

    -  ``Contribution Adult``

      Enter the contribution to be paid for each adult (on top of the threshold number of members). Decimal up to two digits.

    -  ``Contribution Child``

      Enter the contribution to be paid for each child (on top of the threshold number of members). Decimal up to two digits.

    -  ``Insurance Period``

      Enter duration of the period in months, in which a policy with the product will be valid. Mandatory.

    -  ``Administration Period``

      Enter duration of the administration period in months. The administration period is added to the enrolment date/renewal date for determination of the policy start date.

    -  ``Max Instalments``
      Enter maximal number of instalments in which contributions for a policy may be paid. Mandatory.

    -  ``Grace Period Payment``

      Enter duration of the period in months, in which a policy has a grace period (not fully paid up) before it is suspended. Mandatory, although it is by default and can be left at zero.

    -  ``Grace Period Enrolment``

      Enter duration of the period in months after the starting date of a cycle (including this starting date), in which underwriting of a policy will still be associated with this cycle.

    -  ``Grace Period Renewal``

      Enter duration of the period in months after the starting date of a cycle (including this starting date), in which renewing of a policy will still be associated with this cycle.

    -  ``Enrolment Discount percentage``

      Enter the enrolment discount percentage for the insurance product. The discount percentage is applied on the total contributions calculated for a policy underwritten earlier than ``Enrolment disc. period`` months before the start date of the corresponding cycle.

    -  ``Enrolment Discount Period``

      Enter the enrolment discount period of the insurance product in months.

    -  ``Renewal Discount Percentage``

      Enter the renewal discount percentage for the insurance product. The discount percentage is applied on the total contributions calculated for a policy renewed earlier than ``renewal disc. period`` months before the start date of the corresponding cycle.

    -  ``Renewal Discount Period``

      Enter the renewal discount period of the insurance product in months.

    -  ``Medical Services``

      Select from the list of available medical services (from the register of Medical Services) the medical services covered within the insurance product, by either clicking on the ``Check All`` box at the top of the list of medical services, or by selectively clicking on the check box to the left of the medical service.

    -  ``Medical Services Grid``

    .. _image 12:
    .. figure:: /img/user_manual/image14.png
      :align: center

      `Image 12 - Medical Services - Product`

..

      -  **Code**: Displays the code for the medical service

      ..

      -  **Name**: Displays the name of the medical service

      ..

      -  **Type**: Displays the type of the medical service\

      ..

      -  **Level**: Displays the level of the medical service

      ..

      -  **Limit**: Indicates the type of limitation of coverage for the medical service. This may be adjusted per medical service, select between Co-Insurance [C] and Fixed amount [F]. Co-insurance means coverage of a specific percentage of the price of the medical service by policies of the insurance product. Fixed amount means coverage up the specified limit. C is the default value. Limit O is used for claims having the type of visit Other, Limit R is used for claims having the type of visit Referral and Limit E is used for claims having the type of visit Emergency.

      ..

      -  **Origin**: Indicates where the price for remuneration of the service comes from. This may be adjusted per service, the options are: [P] Price taken from the price list of a claiming health facility, [O] Price taken from a claim and [R] Relative price, the nominal value of which is taken from the price list and the actual value of which is determined backwards according to available funds and volume of claimed services and medical items in a period. [R] is the default value.

      ..

      -  **Adult**: Indicates the limitation for adults. If the type of limitation is a co-insurance then the value is the percentage of the price covered by policies of the insurance product for adults. If the type of limitation is a fixed limit the value is an amount up to which price of the service is covered for adults by policies of the insurance product. Default is 100%. Adult O is for Other, Adult R is for Referral and Adult E is for Emergency claims according to the type of visit (Visit Type).

      ..

      -  **Child**: Indicates the limitation for children. If the type of limitation is a co-insurance then the value is the percentage of the price covered for children by policies of the insurance product. If the type of limitation is a fixed limit the value is an amount up to which price of the service is covered for children by policies of the insurance product. Default is 100%. Child O is for Other, Child R is for Referral and Child E is for Emergency claims according to the type of visit (Visit Type).

      ..

      -  **No Adult**: It indicates the maximal number of provisions of the medical service during the insurance period for an adult.

      ..

      -  **No Child**: It indicates the maximal number of provisions of the medical service during the insurance period for an child.

      ..

      -  **Waiting Period Adult**: Indicates waiting period in months (after the effective date of a policy) for an adult.

      ..

      -  **Waiting Period Child**: Indicates waiting period in months (after the effective date of a policy) for a child.

      ..

      -  **Ceiling Adult**: It indicates whether the medical service is excluded from comparison against ceilings defined in the insurance product for adults. Default is that the medical service is not excluded from comparisons with ceilings. [H] means exclusion only for provision of in-patient care, [N] means exclusion only for out-patient care and [B] means exclusion both for in-patient and out-patient care.

      ..

      -  **Ceiling Child**: It indicates whether the medical service is excluded from comparison against ceilings defined in the insurance product for children. Default is that the medical service is not excluded from comparisons with ceilings. [H] means exclusion only for provision of in-patient care, [N] means exclusion only for out-patient care and [B] means exclusion both for in-patient and out-patient care.

    -  ``medical items``

      Select from the list of available medical items (from the register of Medical Items) the medical items covered within the product; by either clicking on the Check All box at the top of the list of medical items, or by selectively clicking on the check box to the left of the medical item.

    -  ``medical items grid``

    .. _image 13:
    .. figure:: /img/user_manual/image15.png
      :align: center

      `Image 13 - Medical Items - Product`

..

      -  **Code**: Displays the code for the medical item

      ..

      -  **Name**: Displays the name of the medical item

      ..

      -  **Type**: Displays the type of the medical item

      ..

      -  **Package**: Displays the packaging of the medical Item

      ..

      -  **Limit**: Indicates the type of limitation of coverage for the medical item. This may be adjusted per medical item, select between Co-Insurance [C] and Fixed amount [F]. Co-insurance means coverage of a specific percentage of the price of the medical item by policies of the insurance product. Fixed amount means coverage up the specified limit. C is the default value. Limit O is used for claims having the type of visit Other, Limit R is used for claims having the type of visit Referral and Limit E is used for claims having the type of visit Emergency.

      ..

      -  **Origin**: It indicates where the price for remuneration of the item, comes from: This may be adjusted per medical item, the options are: [P] Price taken from the price list of a claiming health facility, [O] Price taken from a claim and [R] Relative price, the nominal value of which is taken from the price list and the actual value of which is determined backwards according to available funds and the volume of claimed services and medical items in a period. [R] is the default value.

      ..

      -  **Adult**: It indicates the limitation for adults. If the type of limitation is a co-insurance then the value is the percentage of the price covered for adults by policies of the insurance product. If the type of limitation is a fixed limit the value is an amount up to which price of the item is covered for adults by policies of the insurance product. Default is 100%. Adult O is for Other, Adult R is for Referral and Adult E is for Emergency claims according to the type of visit (Visit Type).

      ..

      -  **Child**: It indicates the limitation for children. If the type of limitation is a co-insurance then the value is the percentage of the price covered for children by policies of the insurance product. If the type of limitation is a fixed limit the value is an amount up to which price of the service is covered for children by policies of the insurance product. Default is 100%. Child O is for Other, Child R is for Referral and Child E is for Emergency claims according to the type of visit (Visit Type).

      ..

      -  **No Adult**: It indicates the maximal number of provisions of the medical item during the insurance period for an adult.

      ..

      -  **No Child**: It indicates the maximal number of provisions of the medical item during the insurance period for a child.

      ..

      -  **Waiting Period Adult**: It indicates waiting period in months (after the effective date of a policy) for an adult.

      ..

      -  **Waiting Period Child**: It indicates waiting period in months (after effective date of a policy) for a child.

      ..

      -  **Ceiling Adult**: It indicates whether the medical item is excluded from comparison against ceilings defined for adults in the insurance product. The default is that the medical item is not excluded from comparisons with ceilings. [H] means exclusion only for provision of in-patient care, [N] means exclusion only for out-patient care and [B] means exclusion both for in-patient and out-patient care.

      ..

      -  **Ceiling Child**: It indicates whether the medical item is excluded from comparison against ceilings defined for children in the insurance product. The default is that the medical item is not excluded from comparisons with ceilings. [H] means exclusion only for provision of in-patient care, [N] means exclusion only for out-patient care and [B] means exclusion both for in-patient and out-patient care.


    -  ``Account Code Remuneration``

      Enter the account code of the insurance product used in the accounting software for remuneration of the product. 25 characters maximum.

    -  ``Account Code Contribution``

      Enter the account code of the insurance product used in the accounting software for paid contributions. 25 characters maximum.

    -  ``Registration Lump Sum``

      Enter the lump sum (for a household/group) for registration fee to be paid at the first enrolment of the household/group. Registration fee is not paid for renewals of policies.

    -  ``Assembly Lump Sum``

      Enter the lump sum (for a household/group) for additional assembly fee to be paid both at the first enrolment and renewals of policies.

    -  ``Registration Fee``

      Enter the registration fee per member of a household/group. If registration lump sum is non zero, registration fee is not considered. Registration fee is not paid for renewals of policies.

    -  ``Assembly Fee``

      Enter the assembly fee per member of a household/group. If assembly lump sum is non zero, assembly fee is not considered. Assembly fee is paid both at the first enrolment and renewals of policies.

    -  ``Start Cycle 1``

    -  ``Start Cycle 2``

    -  ``Start Cycle 3``

    -  ``Start Cycle 4``

      If one or more starting dates (a day and a month) of a cycle are specified then the insurance product is considered as the insurance product with fixed enrolment dates. In this case, activation of underwritten and renewed policies is accomplished always on fixed dates during a year. Maximum four cycle dates can be specified.

    -  ``Ceiling Interpretation``

      Specify whether Hospital and Non-Hospital care should be determined according to the type of health facility (select [Hospital]) that provided health care or according to the type of health care (select [In-patient]) acquired from a claim. In the first case all health care provided in hospitals (defined in the field ``HF Level`` in the register of Health Facilities) is accounted for ``Hospital Ceilings/Deductibles`` and for calculation of relative prices for the ``Hospital`` part. It means that if clamed health care was provided out-patient in a hospital, it is considered for calculation of ceilings/deductibles and for calculation of relative prices as hospital care. In the second case only in-patient care (determined from a claim when a patient spent at least one night in a health facility) is accounted for ``Hospital Ceilings/Deductibles`` and for calculation of relative prices for hospital part. Other health care including out-patient care provided in hospitals is accounted for ``Non hospital Ceilings/Deductibles`` and also such health care is used for calculation of relative prices for non-hospital part. Mandatory.

    -  ``Treatment``

      Deductibles and Ceilings for treatments may be entered for general care (``Hospitals and Non-hospitals``) or for hospital care (``Hospitals``) only and/or for non-hospital care (``Non-Hospitals``) only. An amount may be set, indicating the value that a patient should cover within his/her own means, before a policy of the insurance product comes into effect (``Deductibles``) or the ceiling (maximum amount covered) within a policy of the insurance product (``Ceilings``) for a treatment (the treatment is identified health care claimed in one claim)

    -  ``Insuree``

      Deductibles and Ceilings for an insuree may be entered for general care (``Hospitals and Non-hospitals``) or for hospital care (Hospitals) only and/or for non-hospital care (``Non-Hospitals``) only. An amount may be set, indicating the value that an insuree should cover within his/her own means, before a policy of the insurance product comes into effect (``Deductibles``) or the ceiling (maximum amount covered) within a policy of the insurance product (``Ceilings``) for an insuree for the whole insurance period.

    -  ``Policy``

      Deductibles and Ceilings for a policy may be entered for general care (``Hospitals and Non-hospitals``) or for hospital care (``Hospitals``) only and/or for non-hospital care (Non-Hospitals) only. An amount may be set, indicating the value that policy holders should cover within their own means, before a policy of the insurance product comes into effect (``Deductibles``) or the ceiling (maximum amount covered) for the policy (all members of a family/group) of the insurance product (``Ceilings``) for the whole insurance period.

    -  ``Extra Member Ceiling``

      Additional (extra) ceiling for a policy may be entered for general care (``Hospitals`` and ``Non-hospitals``) or for hospital care (``Hospitals``) only and/or for non-hospital care (``Non-Hospital`` s ) only per a member of a family/group above ``Threshold Members``.

    -  ``Maximum Ceiling``

      Maximal ceiling for a policy may be entered for general care (``Hospitals`` and ``Non-hospitals``) or for hospital care (``Hospitals``) only and/or for non-hospital care (``Non-Hospitals``) only if extra ceilings are applied for members of a family/group above ``Threshold Members``.

    -  ``Number``

      Maximal number of covered claims per an insuree during the whole insurance period according to the category of a claim. The options are claims of the category ``Consultations``, ``Surgery``, ``Delivery`` and ``Antenatal care``. Maximal numbers may be also specified for Hospitalizations (in-patient stays) and (out-patient visits) ``Visits``. The claim category is determined as follows:

    +-----------------------------------------------------------------------+
    | If at least one service of the category *Surgery* is given in the     |
    | claim it is of category *Surgery*                                     |
    |                                                                       |
    | otherwise                                                             |
    |                                                                       |
    | if at least one service of the category *Delivery* is given in the    |
    | claim it is of category *Delivery*                                    |
    |                                                                       |
    | otherwise                                                             |
    |                                                                       |
    | if at least one service of the category *Antenatal care* is given in  |
    | the claim it is of category *Antenatal care*                          |
    |                                                                       |
    | otherwise                                                             |
    |                                                                       |
    | if the claim is a hospital one the claim it is of category            |
    | *Hospitalization*                                                     |
    |                                                                       |
    | otherwise                                                             |
    |                                                                       |
    | if at least one service of the category *Consultation* is given in    |
    | the claim it is of category *Consultation*                            |
    |                                                                       |
    | otherwise                                                             |
    |                                                                       |
    | the claim is of the category *Visit*                                  |
    +-----------------------------------------------------------------------+

    -  ``Ceiling``

      Maximal amount of coverage can be specified for claims according to the category of a claim. The options are claims of the category ``Consultations``, ``Surgery``, ``Delivery``, ``Antenatal care``, Hospitalizations, and ``Visits``. The category of claim is determined according to the procedure described with ``Number``.

      `Note. It is possible to specify only one of the following ceilings –per Treatment, per Insuree or per Policy. If ceilings per category of claims are specified together with ceilings per Treatment, per Insuree or per Policy than evaluation of claims may be dependent under special circumstances on the order of claimed medical services/items in a claim.`

    -  ``distribution Period``

      Distribution periods may be entered for general care (``Hospitals`` and ``Non-hospitals``), or for hospital care (``Hospitals``) only and/or for non-hospital care (``Non-Hospitals``) only. Select from the list (**NONE, Monthly, Quarterly, Yearly**), the period that is to be used for calculation of the actual value of relative prices for the insurance product; by clicking on the arrow on the right. The default value is ‘\ **NONE**\ ’ which means that relative prices are not calculated for general health care or for hospital care or non-hospital care within the insurance product. By selecting **Monthly, Quarterly** or **Yearly** will cause a pop-up (:ref:`image14`) with the relative periods (1 period for yearly, 4 for quarterly, 12 for monthly). Percentages should be entered to indicate the distribution over the periods as per the product description. Enter to each field an appropriate percentage of paid contributions for policies of the insurance product allocated proportionally to corresponding calendar period. It means, for example, that in case of the distribution **Monthly** we put in each slot percentage of paid contributions of the insurance product that are allocated to the corresponding month and that is to be used for calculation of relative prices.

      It is not required to enter a value in each period, zero values are accepted. Once all the percentage values have been entered, click on the button OK to submit the values to the respective grid. Clicking on the button ``Cancel`` will cancel the action closing the popup and cancelling the change in the distribution.

    .. _image14:
    .. |logo9| image:: /img/user_manual/image16.png
      :scale: 100%
    .. |logo10| image:: /img/user_manual/image17.png
      :scale: 100%
    .. |logo11| image:: /img/user_manual/image18.png
      :scale: 100%

    +-------+--------+--------+
    ||logo9|||logo10|||logo11||
    +-------+--------+--------+

      `Image 14 - Distribution Periods (Monthly – Quarterly – Yearly) - Product)`

  ``Capitation Payment``

  The section allows definition of parameters of a capitation formula used for remuneration of selected levels of health facilities within the insurance product. The report `Capitation Payment` is used for calculation of the amount of capitation payment for individual health facilities. The parameters of the capitation formula are the following:

    -  ``Level 1``

      The first level of health facilities can be selected that should be included in the calculation of capitation payments. The options are the following levels of a health facility: Dispensary, Health Centre, and Hospital.

    -  ``Sub Level 1``

      The sub-level of the first level of health facilities can be selected that should be included in calculation of capitation payments. If the sub level is not selected, all health facilities of the specified level are included irrespective of their sub-level.

    -  ``Level 2``

      The second level of health facilities can be selected that should be included in the calculation of capitation payments. The options are the following levels of a health facility: ``Dispensary``, ``Health Centre``, and ``Hospital``.

    -  ``Sub Level 2``

      The sub-level of the second level of health facilities can be selected that should be included in calculation of capitation payments. If the sub level is not selected, all health facilities of the specified level are included irrespective of their sub-level.

    -  ``Level 3``

      The third level of health facilities can be selected that should be included in the calculation of capitation payments. The options are the following levels of a health facility: ``Dispensary``, ``Health Centre``, and ``Hospital``.

    -  ``Sub Level 3``

      The sub-level of the third level of health facilities can be selected that should be included in calculation of capitation payments. If the sub level is not selected, all health facilities of the specified level are included irrespective of their sub-level.

    -  ``Level 4``

      The fourth level of health facilities can be selected that should be included in the calculation of capitation payments. The options are the following levels of a health facility: ``Dispensary``, ``Health Centre``, and ``Hospital``.

    -  ``Sub Level 4``

      The sub-level of the fourth level of health facilities can be selected that should be included in calculation of capitation payments. If the sub level is not selected, all health facilities of the specified level are included irrespective of their sub-level.

    -  ``Share of Contribution``

      The share of allocated contributions for given insurance product and the period specified for the report Capitation Payment that should be used for calculation of capitation payments for individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Population``

      The weight can be entered that is used for the number of population living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Number of Families``

      The weight can be entered that is used for the number of families living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Insured Population``

      The weight can be entered that is used for the number of insured population by given insurance product and living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Number of Insured Families``

      The weight can be entered that is used for the number of insured families by given insurance product and living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Number of Visits``

      The weight can be entered that is used for the number of contacts of insured by given insurance product and living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

    -  ``Weight of Adjusted Amount``

      The weight can be entered that is used for the adjusted amount on claims for insured by given insurance product and living in catchments areas of individual health facilities. The amount specified is interpreted as a percentage.

  *Note. The capitation formula is defined as follows:*

  .. math::`\text{CapitationPayment}_{i} = \sum_{a}^{\ }{(\ \text{Indicator}_{i}^{a}} \times \frac{AllocatedContribution \times ShareContribution \times \text{Share}^{a}}{\sum_{i}^{\ }{\text{In}\text{dicator}}_{i}^{a}})`

  *Where*

  :math:`\text{CapitationPayment}_{i}` *is the amount of capitation payment for i-th health facility*

  :math:`\text{Indicator}_{i}^{a}` *is the value of the indicator of the type a for the i-th health facility.* :math:`\text{Indicator}_{i}^{a}`

  *may be:*

    -  *Population living in catchments area of the health facility*
    -  *Number of families living in catchments area of the health facility*
    -  *Insured population living in catchments area of the health facility*
    -  *Insured number of families living in catchments area of the health facility*
    -  *Number of claims (contacts) with the health facility by insured in the catchment area*
    -  *Adjusted amount*

  :math:`\text{AllocatedContribution}` *is the amount of contributions for given insurance product for given period *

  :math:`\text{ShareContribution}` *is the formula parameter Share of contribution*

  :math:`\text{Share}^{a}` *is the weight of the indicator of the type a .*

  :math:`\text{Share}^{a}` *may be:*

    -  *Weight of Population*
    -  *Weight of Number of Families*
    -  *Weight of Insured Population*
    -  *Weight of Number of Insured Families*
    -  *Weight of Number of Visits*
    -  *Weight of Adjusted Amount*

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Product Control Page <#product-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the product has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Product Control Page <#product-control-page>`__.

Adding a Product
""""""""""""""""

Click on the ``Add`` button to re-direct to the `Product Page <#claim-administrators-administration>`__\ .

When the page opens all entry fields are empty. See the `Product Page <#claim-administrators-administration>`__ information on the data entry and mandatory fields.

Editing a Product
"""""""""""""""""

Click on the ``Edit`` button to re-direct to the `ProductPage <#claim-administrators-administration>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Product Page <#claim-administrators-administration>`__ for information on the data entry and mandatory fields

Duplicating a Product
"""""""""""""""""""""

Click on the ``Duplicate`` button to re-direct to the `Product Page <#claim-administrators-administration>`__\ .

The page will open with all the current information for the selected product, (except for the product code which should be unique), loaded into the data entry fields. See the `Product Page <#claim-administrators-administration>`__ for information on the data entry and mandatory fields. To save the record, enter a unique code before clicking on save.

Deleting a Product
""""""""""""""""""

Because of potential problems with synchronization of data between off-line and on-line version, it is not possible delete insurance products currently.

Health Facilities Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register of health facilities contains all health facilities contracted and/or eligible for submitting of claims by/to the health insurance scheme. Health Facility administration is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A health facility may only be added if the management of the scheme administration contracts it or if eligibility of submitting of claims can be derived from the legislation. It may thereafter be edited; however, approval of the management of the scheme administration is required for a change of the pricelists associated with the health facility. Deletion of a health facility normally will occur when a Health Facility stops its activity or the contract with the health facility with the scheme administration is cancelled.

Navigation
""""""""""

.. _image15:
.. figure:: /img/user_manual/image19.png
  :align: center

  `Image 15 - Navigation Health Facilities`

All functionality for use with the administration of health facilities can be found under the main menu ``Administration``, sub menu ``Health Facilities.``

Clicking on the sub menu ``Health Facilities`` re-directs the current user to the `Health Facilities Control Page <#health-facilities-control-page>`__\.

.. _image16:
.. figure:: /img/user_manual/image20.png
  :align: center

  `Image 16 - Health Facilities Control Page`

Health Facilities Control PAGE
""""""""""""""""""""""""""""""

The ``Health Facilities Control Page`` is the central point for all health facilities administration. By having access to this page, it is possible to add, edit, delete and search. The page is divided into four panels (:ref:`image16`)

  A. Search Panel

  The Search Panel allows a user to select specific criteria to minimise the search results. In the case of health facilities the following search options are available which can be used alone or in combination with each other.

    -  ``Code``

      Type in the beginning of; or the full ``Code``; to search for health facilities with a ``Code``, which starts with or matches completely, the typed text.

    -  ``Name``

      Type in the beginning of; or the full ``Name``; to search for health facilities with a ``Name``, which starts with or matches completely, the typed text.

    -  ``Fax``

      Type in the beginning of; or the full ``Fax`` to search for health facilities with a ``Fax``, which starts with or matches completely, the typed number.

    -  ``Level``

      Select the ``Level``; from the list of levels of health facilities (Dispensary, Health Centre, Hospital) by clicking on the arrow on the right of the selector, to select health facilities of a specific level of service.

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for health facilities with a ``Phone Number``, which starts with or matches completely, the typed number.

    -  ``Email``

      Type in the beginning of; or the full ``Email`` to search for health facilities with an ``Email`` which starts with or matches completely, the typed text.

    -  ``Legal Form``

      Select the ``Legal Form``; from the list of legal forms (Government, District organization, Private Organisation, Charity) by clicking on the arrow on the right of the selector, to select health facilities of a specific legal form.

    -  ``Region``

      Select the ``Region``; from the list of districts by clicking on the arrow on the right of the selector to select health facilities from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then this region will be automatically selected.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select health facilities from a specific district. *Note: The list will only be filled with the districts that belong to the selected region and that are assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``Care Type``

      Select the ``Care Type`` from the list of types (In-patient, Out-patient, Both) of provided health care by clicking on the arrow on the right of the selector, to select health facilities with a specific type.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image17`)

    .. _image17:
    .. figure:: /img/user_manual/image21.png
      :align: center

      `Image 17 - Historical Records - Result Panel`

    -  ``Search button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The result panel displays a list of all health facilities found, matching the selected Criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image18`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image18:
  .. figure:: /img/user_manual/image22.png
    :align: center

    `Image 18 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image19`)

  .. _image19:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 19 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the health facility page, the button panel (the buttons ``Edit`` and ``Delete)`` is used in conjunction with the current selected record (highlighted with blue). The user should select first a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a health facility has been added, updated or deleted or if there was an error at any time during the process of these actions.

Health Facility Page
""""""""""""""""""""

  **1. Data Entry**

  .. _image20:
  .. figure:: /img/user_manual/image23.png
    :align: center

    `Image 20 - Health Facility Page`

..

    -  ``Code``

      Enter the code for the health facility. Mandatory, 8 characters.

    -  ``name``

      Enter the name for the health facility. Mandatory, 100 characters maximum.

    -  ``Legal Form``

      Select the legal form of the health facility from the list (Government, District organization, Private Organisation, Charity), by clicking on the arrow on the right hand side of the lookup.  Mandatory.

    -  ``Level``

      Select a level from the list levels (Dispensary, Health Centre, Hospital), by clicking on the arrow on the right hand side of the lookup. Mandatory.

    -  ``Sub Level``

      Select a sub-level from the list sub-levels (No Sublevel, Integrated, Reference), by clicking on the arrow on the right hand side of the lookup. Mandatory.

    -  ``Address``

      Enter the address of the health facility. Mandatory, 100 characters maximum.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow  on the right of the selector to enter the region in which the health facility is located. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then this region will be automatically selected.* Mandatory.

    -   ``District``

      Select the ``district``; from the list of districts by clicking on the arrow on the right of the selector to enter the district in which the health facility is located. *Note: The list will only be filled with the districts assigned to the selected region and to districts assigned to the currently logged in user. If this is only one then the district will be automatically selected.* Mandatory.

    -  ``Phone Number``

      Enter the phone number for the health facility. 50 characters maximum.

    -  ``Fax``

      Enter the fax number for the health facility. 50 characters maximum.

    -  ``Email``

      Enter the email for the health facility. 50 characters maximum.

    -  ``Care Type``

      Select the type of health care provided by the health facility from the list (In-patient, Out-patient, Both), by clicking on the arrow on the right hand side of the lookup. Mandatory.

    -  ``Price Lists (Medical Services)``

      Select the health facilities price lists (for medical services) from the list by clicking on the arrow on the right hand side of the lookup. The pricelist contains the list of medical services and their prices agreed between the health facility (or corresponding group of health facilities) and the scheme administration which can be invoiced by the health facility and remunerated by the scheme administration. *Note: The list will only be filled with the pricelists associated with the previously selected district, regional and nationwide pricelists assigned to the current logged in user.*

    -  ``Price Lists (Medical Items)``

      Select the health facilities price lists (medical items) from the list by clicking on the arrow on the right hand side of the lookup. The pricelist contains the list of medical items and their prices agreed between the health facility (or corresponding group of health facilities) and the scheme administration which can be invoiced by the health facility and remunerated by the scheme administration. *Note: The list will only be filled with the pricelists associated with the previously selected district, regional and nationwide pricelists assigned to the current logged in user.*

    -  ``Account Code``

      Enter the account code (Identification for the accounting software), which will be used in reports on remuneration to be received by the health facility. 25 characters maximum.

    -  ``Region, District, Municipality, Village, Catchment grid``

      Check the locations that define the catchment area of the health facility. Specify the percentage of the population of a village that belong to the catchment area in the catchment column. Default is 100%.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the ``Health Facility Control Page``, with the newly saved record displayed and selected in the result panel. A message confirming that the health facility has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Health Facilities Control Page <#health-facilities-control-page>`__.

Adding a Health Facility
""""""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Health Facility Page <#health-facility-page>`__

When the page opens all entry fields are empty. See the `Health Facility Page <#health-facility-page>`__ for information on the data entry and mandatory fields.

Editing a Health Facility
"""""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Health Facility Page <#health-facility-page>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Health Facility Page <#health-facility-page>`__ for information on the data entry and mandatory fields

Deleting a Health Facility
""""""""""""""""""""""""""

Click on the ``Delete`` button to delete the currently selected record.

Before deleting a confirmation popup (:ref:`image21`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image21:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 21 - Delete confirmation- Button Panel`

When a health facility is deleted, all records retaining to the deleted health facility will still be available by selecting historical records.

Medical Services Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register of Medical Services contains all medical services that can be included in packages of benefits of insurance products administered and remunerated by the health insurance scheme. Administration of the register of medical services is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A medical service may only be added or thereafter edited or deleted, after the approval of the management of the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of Medical Services can be found under the main menu ``Administration``, sub menu ``Medical Services.``

.. _image22:
.. figure:: /img/user_manual/image25.png
  :align: center

  `Image 22 - Navigation Medical Services`

Clicking on the sub menu ``Medical Services`` re-directs the current user to the `Medical Services Control Page <#medical-services-control-page>`__\.

.. _image23:
.. figure:: /img/user_manual/image26.png
  :align: center

  `Image 23 - Medical Services Control Page`

Medical Services Control Page
"""""""""""""""""""""""""""""

The ``Medical Services Control Page`` is the central point for all medical service administration. By having Access to this panel, it is possible to add, edit, delete and search. The panel is divided into four panels (:ref:`image23`)

  A. Search Panel

  The Search Panel allows a user to select specific criteria to minimise the search results. In the case of medical services the following search options are available which can be used alone or in combination with each other.

    -  ``Code``

      Type in the beginning of; or the full ``Code``; to search for medical services with a ``Code``, which starts with or matches completely, the typed text.

    -  ``Name``

      Type in the beginning of; or the full ``Name`` to search for medical services with a ``Name``, which starts with or matches completely, the typed text.

    -  ``Type``

      Select the ``Type``; from the list of types (Preventive, Curative) by clicking on the arrow on the right of the selector, to select medical services of a specific type.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image24`)

    .. _image24:
    .. figure:: /img/user_manual/image27.png
      :align: center

      `Image 24 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the result panel.

  B. Result Panel

  The Result Panel displays a list of all medical services found, matching the selected Criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image25`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image25:
  .. figure:: /img/user_manual/image28.png
    :align: center

    `Image 25 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image26`).

  .. _image26:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 26 - Page Selector - Result Panel`

  C. Button Panel

  With exception of the cancel button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Medical Service Page <#medical-service-page>`__, the button panel (the buttons ``End`` and ``Delete``) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a medical service has been added, updated or deleted or if there was an error at any time during the process of these actions.

Medical Service Page
""""""""""""""""""""

  **1. Data Entry**

  .. _image27:
  .. figure:: /img/user_manual/image29.png
    :align: center

    `Image 27 - Medical Service Page`

..

    -  ``Code``

      Enter the code for the medical service. Mandatory, 6 characters.

    -  ``Name``

      Enter the name of the medical service. Mandatory, 100 characters maximum.

    -  ``Category``

      Choose the category (Surgery, Consultation, Delivery, Antenatal, Other) which the medical service belongs to.

    -  ``Type``

      Choose one from the options available (Preventive, Curative), the type of the medical service. Mandatory.

    -  ``Level``

      Select from the list )Simple Service, Visit, Daz of Staz, Hospital Case), the level for the medical service. Mandatory.

    -  ``Price``

      Enter the price a general price that can be overloaded in pricelists. Full general price (including potential cost sharing of an insuree) for the medical service. Mandatory.

    -  ``Care Type``

      Choose one from the options available (Out-patient, In-patient, Both), the limitation of provision of the medical service to the specific type of health care. Mandatory.

    -  ``Frequency``

      Enter the limitation of frequency of provision in a number of days within which a medical service can be provided to a patient not more than once. If the frequency is zero, there is no limitation. *Note: By default the frequency is 0.*

    -  ``Patient``

      Choose one or a combination of the options available, to specify which patient type the medical service is applicable to. *Note: By default all patient options are checked (selected).*

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Medical Services Control Page <#medical-services-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the medical service has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Medical Services Control Page <#medical-services-control-page>`__.

Adding a Medical Service
""""""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Medical Service Page <#medical-service-page>`__\ .

When the page opens all entry fields are empty. See the `Medical Service Page <#medical-service-page>`__ for information on the data entry and mandatory fields.

Editing a Medical Service
"""""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Medical Service Page <\l>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Medical Service Page <#medical-service-page>`__ for information on the data entry and mandatory fields.

Deleting a Medical Service
""""""""""""""""""""""""""

Click on the ``Cancel`` button to delete the currently selected record; the user is re-directed the `Medical Services Control Page <#medical-services-control-page>`__\.

Before deleting a confirmation popup (:ref:`image28`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image28:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 28 - Delete confirmation- Button Panel`

When a medical service is deleted, all records retaining to the deleted medical service will still be available by selecting historical records.

Medical Items Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register of Medical Items contains all medical items (drugs, prostheses) that can be included in packages of benefits of insurance products within the health insurance scheme and are remunerated by the scheme administration. Administration of the register of medical items is restricted to users with the role of Scheme Administrator

Pre-conditions
""""""""""""""

A medical item may only be added or thereafter edited or deleted, after the approval of the management of the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of medical items can be found under the main menu ``Administration``, sub menu ``Medical Items``

.. _image29:
.. figure:: /img/user_manual/image30.png
  :align: center

  `Image 29 - Navigation Medical Items`

Clicking on the sub menu ``Medical Items`` re-directs the current user to the `Medical Items Control Page <#medical-items-control-page>`__\.

.. _image30:
.. figure:: /img/user_manual/image31.png
  :align: center

  `Image 30 - Medical Items Control Page`

Medical Items Control Page
""""""""""""""""""""""""""

The ``Medical Items Control Page`` is the central point for all medical item administration. By having access to this page, it is possible to add, edit, delete and search. The panel is divided into four panels (:ref:`image30`)

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of medical items the following search options are available which can be used alone or in combination with each other.

    -  ``Code``

      Type in the beginning of; or the full ``Code``; to search for medical items with a ``Code``, which starts with or matches completely, the typed text.

    -  ``Name``

      Type in the beginning of; or the full ``Name`` to search for medical items with a ``Name``, which starts with or matches completely, the typed text.

    -  ``Type``

      Select the ``Type``; from the list of types (Drugs, Medical Prostheses) by clicking on the arrow on the right of the selector, to select medical items of a specific type.

    -  ``Package``

      Type in the beginning of; or the full ``Package``; to search for medical items with a ``Package``, which starts with or matches completely, the typed text.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image31`).

    .. _image31:
    .. figure:: /img/user_manual/image32.png
      :align: center

      `Image 31 - Historical records - Result Panel`

    -  ``Search button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The result panel displays a list of all medical items found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image32`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image32:
  .. figure:: /img/user_manual/image33.png
    :align: center

    `Image 32 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image33`)

  .. _image33:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 33 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Medical Item Page <#medical-item-page>`__, the button panel (the buttons ``Edit`` and ``Delete``) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a medical item has been added, updated or deleted or if there was an error at any time during the process of these actions.

Medical Item Page
"""""""""""""""""

  **1. Data Entry**

  .. _image34:
  .. figure:: /img/user_manual/image34.png
    :align: center

    `Image 34 - Medical Item Page`

..

    -  ``Code``

      Enter the code for the medical item. Mandatory, 6 characters.

    -  ``Name``

      Enter the name of the medical item. Mandatory, 100 characters maximum.

    -  ``Type``

      Choose one from the options available, the type of the medical item. Mandatory.

    -  ``Package``

      Enter the package (Indication of type and volume of package in a suitable coding system) for the medical item. Mandatory, 255 characters maximum.

    -  ``Price``

      Enter the price (a general price that can be overloaded in pricelists). Full general price including potential cost sharing of an insuree) for the medical item. Mandatory.

    -  ``Care Type``

      Choose one from the options available, the limitation of provision of the medical item within the specific type of health care (In-patient, Out-patient or Both). Mandatory.

    -  ``Frequency``

      Enter the limitation of frequency of provision in a number of days within which a medical item cannot be provided to a patient not more than once. If the frequency is zero, there is no limitation. *Note: By default the frequency is 0.*

    -  ``Patient``

      Choose one or a combination of the options available, to specify which patient type the medical item may be provided to. *Note: By default all patients’ options are checked (selected).*

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Medical Items Control Page <#medical-items-control-page>`__, with the newly saved record displayed and selected in the Result Panel. A message confirming that the medical item has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Medical Items Control Page. <#medical-items-control-page>`__

Adding a Medical Item
"""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Medical Item Page <#medical-item-page>`__\ .

When the page opens all entry fields are empty. See the `Medical Item Page <#medical-item-page>`__ for information on the data entry and mandatory fields.

Editing a Medical Item
""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Medical Item Page <#medical-item-page>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Medical Item Page <#medical-item-page>`__ for information on the data entry and mandatory fields.

Deleting a Medical Item
"""""""""""""""""""""""

Click on the ``Delete`` button to delete the currently selected record

Before deleting a confirmation popup (:ref:`image35`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image35:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 35 - Delete confirmation- Button Panel`

When the medical item is deleted, all records retaining to the deleted medical item will still be available by selecting historical records.

Medical Service Price Lists Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Price lists of medical services are tools for specification which medical services and at which prices can be invoiced by contractual health facilities to the scheme administration. Administration of price lists of medical services is restricted to users with the role of Scheme Administrator

Pre-conditions
""""""""""""""

A price list of medical services may only be added, after an agreement with a health facility or a group of health facilities on specific prices. Editing of the price list may occur only after an approval of the management of the scheme administration. Deletion of a price list of medical services normally will occur when a price list becomes obsolete.

Navigation
""""""""""

All functionality for use with the administration of price lists medical services can be found under the main menu ``Administration``, sub menu ``Price Lists`` and sub menu ``Medical Services``

.. _image35:
.. figure:: /img/user_manual/image35.png
  :align: center

  `Image 35 - Navigation Medical Services Price Lists`

Clicking on the sub menu ``Medical Services`` re-directs the current user to the `Price List Medical Services Control Panel. <#price-list-medical-services-control-page>`__

.. _image36:
.. figure:: /img/user_manual/image36.png
  :align: center

  `Image 36 - Price List Medical Service Control Panel`

Price List Medical Services Control Page
""""""""""""""""""""""""""""""""""""""""

The ``Price List Medical Services Control Page`` is the central point for administration of all price lists of medical service. By having access to this panel, it is possible to add, edit, delete and search. The panel is divided into four panels (:ref:`image36`)

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of price lists for medical services the following search options are available which can be used alone or in combination with each other.

    -  ``Name``

      Type in the beginning of; or the full ``Name``; to search for price lists medical services with a ``Name``, which starts with or matches completely, the typed text.

    -  ``Date``

      Type in the full ``Date`` to search for price lists of medical services with a creation ``Date`` which matches completely, the typed date. *Note: You can also use the button next to the date field to select a date.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image37`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

      -  Anytime during the use of the pop-up, the user can see the date of today.
      -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
      -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
      -  Clicking on the arrow to the left displays the previous month.
      -  Clicking on the arrow on the right will displays the following month.
      -  Clicking on the month will display all the months for the year.
      -  Clicking on the year will display a year selector.

      .. _image37:
      .. |logo12| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo13| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo14| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++---------++---------+
      | |logo12| || |logo13||| |logo14||
      +----------++---------++---------+

        `Image 37 - Calendar Selector - Search Panel`

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select price lists of medical services from a specific region. The option **National** means that the price list is common for all regions. *Note: The list will only be filled with the regions assigned to the current logged in user and with the option National. All nationwide pricelists and all regional pricelists relating to the selected region will be found. If no district is selected then also all district pricelists for districts belonging to the selected region and assigned to the currently logged in user will be found.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select price lists of medical services from a specific district. *Note: The list will be only filled with the districts belonging to the selected region. All nationwide pricelists, all regional pricelists relating to the selected region and all district pricelists for the selected district will be found.*

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image38`)

    .. _image38:
    .. figure:: /img/user_manual/image37.png
      :align: center

      `Image 38 - Historical records - Result Panel`

    -  ``Search button``

      Once the criteria have been entered, use the search button to filter  the records, the results will appear in the Result Panel.

  B. Result Panel

  The Result Panel displays a list of all price lists of medical services found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image39`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image39:
  .. figure:: /img/user_manual/image38.png
    :align: center

    `Image 39 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image40`)

  .. _image40:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 40 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Price List Medical Service Page <#price-list-medical-services-page>`__, the Button Panel (the buttons ``Edit`` and ``Duplicate`` ) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a price list of medical services has been added, updated or deleted or if there was an error at any time during the process of these actions.

Price List Medical Services Page
""""""""""""""""""""""""""""""""

  **1. Data Entry**


  .. _image41:
  .. figure:: /img/user_manual/image39.png
    :align: center

    `Image 41 - Price List Medical Service Page`

..

    -  ``Name``

      Enter the name for the price list of medical services. Mandatory, 100 characters maximum.

    -  ``Date``

      Enter the creation date for the price list of medical services. *Note: You can also use the button next to the date field to select a date to be entered.*

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to enter the region in which the price list of medical services is to be used. The region **National** means that the price list is common for all regions. *The list will only be filled with the regions assigned to the current logged in user and with the option National.* Mandatory.

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to enter the district in which the price list of medical services is to be used. *Note: The list will be only filled with the districts belonging to the selected region and currently logged in user.* It is not mandatory to enter a district, not selecting a district will mean the price list of medical services is used in all districts of the region or nationwide if the region National is selected.

    -  ``Medical Services``

      Select from the list of available medical services the medical services which the price list of medical service should contain, by either clicking on the ``check all`` box at the top of the list of medical services, or by selectively clicking on the ``check box`` to the left of a medical service. The list shows the medical services displaying the code, name, type and price for reference. There is also an extra column, Overrule, which can be used to overrule the pre-set price. By clicking once on the row desired item in the overrule column, a new price can be entered for the individual service. This occurs when price agreed between a health facility or group of health facilities and the health insurance administration differs from the common price in the register of medical services.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Price List Medical Services Control Page <#price-list-medical-services-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the price list medical service has been saved will appear on the Information Panel.

  **3. Mandatory Data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Price List Medical Services Control Page <#price-list-medical-services-control-page>`__\.

Adding a Price List of Medical Services
"""""""""""""""""""""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Price List Medical Services Page <#price-list-medical-services-page>`__\.

When the page opens all entry fields are empty. See the `Price List Medical Services Page <#price-list-medical-services-page>`__ for information on the data entry and mandatory fields.

Editing a Price List of Medical Services
""""""""""""""""""""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Price List Medical Services Page <#price-list-medical-services-page>`__\.

The page will open with the current information loaded into the data entry fields. See the `Price List Medical Services Page <#price-list-medical-services-page>`__ for information on the data entry and mandatory fields.

Duplicating a Price List of Medical Services
""""""""""""""""""""""""""""""""""""""""""""

Click on the ``Duplicate`` button to re-direct to the `Price List Medical Services Page <#price-list-medical-services-page>`__\.

The page will open with all the current information for the selected pricelist, (except for the pricelist name which should be unique), loaded into the data entry fields. See the `Price List Medical Services Page <#price-list-medical-services-page>`__ for information on the data entry and mandatory fields. To save the record, enter a unique code before clicking on save.

Deleting a Price List of Medical Services
"""""""""""""""""""""""""""""""""""""""""

Click on the ``Delete`` button to delete the currently selected record.

Before deleting a confirmation popup (:ref:`image42`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image42:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 42 - Delete Confirmation - Button Panel`

When a price list medical service is deleted, all records retaining to the deleted price list medical service will still be available by selecting historical records.

Medical Item Price Lists Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pricelists of medical items are tools for specification which medical items and at which prices can be invoiced by contractual health facilities to the scheme administration. Administration of pricelists of medical items is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A price list of medical items may only be added, after an agreement with a health facility or a group of health facilities on specific prices. Editing of the price list may occur only after an approval of the management of the scheme administration. Deletion of a price list of medical Items normally will occur when a price list becomes obsolete.

Navigation
""""""""""

All functionality for use with the administration of medical items price lists can be found under the main menu ``Administration``, sub menu ``Price Lists``, sub menu ``Medical Items.``

.. _image43:
.. figure:: /img/user_manual/image40.png
  :align: center

  `Image 43 - Navigation Price Lists Medical Items`

Clicking on the sub menu ``Medical Items`` re-directs the current user to the `Price List Medical Items Control Page <#price-list-medical-items-control-page>`__\ .

.. _image44:
.. figure:: /img/user_manual/image41.png
  :align: center

  `Image 44 - Price List Medical Items Control Page`

Price List Medical Items Control Page
"""""""""""""""""""""""""""""""""""""

The ``Price List Medical Items Control Page`` is the central point for all medical item price list administration. By having access to this panel, it is possible to add, edit, delete and search. The panel is divided into four panels (:ref:`image47`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of price lists for medical items the following search options are available which can be used alone or in combination with each other.

  -  ``Name``

    Type in the beginning of; or the full ``Name``; to search for price lists medical items with a Name, which starts with or matches completely, the typed text.

  -  ``Date``

    Type in the full ``Date`` to search for price lists of medical items with a creation Date which matches completely, the typed date. *`Note: You can also use the button next to the date field to select a date.*

  -  ``Date Selector Button``

    Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image45`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

    -  At anytime during the use of the pop-up, the user can see the date of today.
    -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
    -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
    -  Clicking on the arrow to the left displays the previous month.
    -  Clicking on the arrow on the right will displays the following month.-  Clicking on the month will display all the months for the year.
    -  Clicking on the year will display a year selector.

    .. _image45:
    .. |logo15| image:: /img/user_manual/image6.png
      :scale: 100%
    .. |logo16| image:: /img/user_manual/image7.png
      :scale: 100%
    .. |logo17| image:: /img/user_manual/image8.png
      :scale: 100%

    +--------+--------+--------+
    ||logo15|||logo16|||logo17||
    +--------+--------+--------+

      `Image 45 - Calendar Selector - Search Panel`

  -  ``Region``

    Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select price lists of medical items from a specific region. The option **National** means that the price list is common for all regions. *Note: The list will only be filled with the regions assigned to the current logged in user and with the option National. All nationwide pricelists and all regional pricelists relating to the selected region will be found. If no district is selected the also all district pricelists for districts belonging to the selected region will be found.*

  -  ``District``

    Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select price lists medical items from a specific district. *Note: The list will be only filled with the districts belonging to the selected region and assigned to the currently logged in user. All nationwide pricelists, all regional pricelists relating to the selected region and all district pricelists for the selected district will be found.*

  -  ``Historical``

    Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image46`).

  .. _image46:
  .. figure:: /img/user_manual/image42.png
   :align: center

   `Image 46 - Historical records - Result Panel`

  -  ``Search button``

    Once the criteria have been entered, use the search button to filter the records, the results will appear in the result panel.

  B. Result Panel

  The Result Panel displays a list of all price lists of medical items found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image47`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image47:
  .. figure:: /img/user_manual/image43.png
   :align: center

   `Image 47 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image48`)

  .. _image48:
  .. figure:: /img/user_manual/image11.png
   :align: center

   `Image 48 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Price List Medical Item Page <#price-list-medical-item-page>`__, the button panel (the buttons ``Edit`` and ``Delete`` ) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a price list medical item has been added, updated or deleted or if there was an error at any time during the process of these actions.

Price List Medical Item Page
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  **1. Data entry**

  .. _image49:
  .. figure:: /img/user_manual/image44.png
    :align: center

    `Image 49 - Price List Medical Item Page`

..

    -  ``Name``

      Enter the name for the price list of medical items. Mandatory, 100 characters maximum.

    -  ``Date``

      Enter the creation date for the price list of medical items. *Note: You can also use the button next to the date field to select a date to be entered.*

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to enter the region in which the price list of medical items is to be used. The district **National** means that the price list is common for all regions. *Note: The list will only be filled with the regions assigned to the current logged in user and with the option National.* Mandatory.

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to enter the district in which the price list of medical items is to be used. *Note: The list will be only filled with the districts belonging to the selected region and currently logged in user.* It is not mandatory to enter a district, not selecting a district will mean the price list of medical items is used in all districts of the region or nationwide if the region National is selected .

    -  ``Medical Items``

      Select from the list of available medical items the medical items which the price list medical item contains, by either clicking on the ``check all box`` at the top of the list of medical items, or by selectively clicking on the ``check box`` to the left of the medical item. The list shows the medical items displaying the code, name, type and price for reference. There is also an extra column, Overrule, which can be used to overrule the pre-set price. By clicking once on the row desired item in the overrule column, a new price can be entered for the individual item. This occurs when price agreed between a health facility or group of health facilities and the health insurance administration differs from the common price in the register of medical items.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Price list Medical Items Control Page <#medical-items-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the price list of medical items has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save button``, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Price List Medical Items Control Page <#medical-items-control-page>`__.\

Adding a Price List of Medical Items
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click on the Add button to re-direct to the `Price List Medical Item Page <#price-list-medical-item-page>`__.\

When the page opens all entry fields are empty. See the `Price List Medical Item Page <#price-list-medical-item-page>`__ for information on the data entry and mandatory fields.\

Editing a Price List of Medical Items
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click on the Edit button to re-direct to the `Price List Medical Item Page <#price-list-medical-item-page>`__\.

The page will open with the current information loaded into the data entry fields. See the `Price List Medical Item Page <#price-list-medical-item-page>`__ for information on the data entry and mandatory fields.

Duplicating a Price List of Medical Items
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click on the Duplicate button to re-direct to the `Price List Medical Item Page <#price-list-medical-item-page>`__\.

The page will open with all the current information for the selected price list, (except for the price list name which should be unique), loaded into the data entry fields. See the `Price List Medical Item Page <#price-list-medical-item-page>`__ for information on the data entry and mandatory fields. To save the record, enter a unique code before clicking on ``Save``.

Deleting a Price List of Medical Items
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click on the ``Delete`` button to delete the currently selected record\; the user is re-directed to the `Price List Medical Items Control Page <#medical-items-control-page>`__\.

Before deleting a confirmation popup (:ref:`image50`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image50:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 50 - Delete confirmation- Button Panel`

When a price list of medical items is deleted, all records retaining to the deleted price list of medical items will still be available by selecting historical records.

Users administration
^^^^^^^^^^^^^^^^^^^^^

User administration is restricted to users with the role of IMIS Administrator.

Pre-conditions
""""""""""""""

A user may only be added or thereafter edited, after the approval of the management of the scheme administration. Deletion of a user normally will occur when a user leaves his/her post within the health insurance scheme and/or the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of users can be found under the main menu ``Administration``, sub menu ``Users``.

.. _image51:
.. figure:: /img/user_manual/image45.png
  :align: center

  `Image 51 - Navigation Users`

Clicking on the sub menu ``Users`` re-directs the current user to the `User Control Page <#user-control-page>`__\ .

 .. _image52:
 .. figure:: /img/user_manual/image46.png
   :align: center

   `Image 52 - User Control Page`

User Control Page
"""""""""""""""""

The ``User Control Page`` is the central point for all user administration. By having access to this page, it is possible to add, edit, delete and search users. The page is divided into four panels (:ref:`image52`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of users the following search options are available which can be used alone or in combination with each other.

    -  ``Last Name``

      Type in the beginning of; or the full Last name; to search for users with a Last name, which starts with or matches completely, the typed text.

    -  ``Login Name``

      Type in the beginning of; or the full Login name, to search for users with a Login name, which starts with or matches completely, the typed text.

    -  ``Phone Number``

      Type in the beginning of; or the full Phone Number, to search for users, with a Phone Number which starts with or matches completely, the typed text.

    -  ``Email``

      Type in the beginning of; or the full Email, to search for users, with an Email which starts with or matches completely, the typed text.

    -  ``Other Names``

      Type in the beginning of; or the full Other Names, to search for users, with Other names which start with or match completely the typed text.

    -  ``Role``

      Select the Role; from the list of roles by clicking on the arrow on the right of the selector, to select users of a specific role.

    -  ``Health Facilities``

      Select the Health Facility; from the list of health facilities by clicking on the arrow on the right of the selector, to select users from a specific health facility. *Note: The list will only be filled with the health facilities belonging to the districts assigned to the currently logged in user.*

    -  ``Region``

      Select the Region; from the list of regions by clicking on the arrow on the right of the selector to find users with access to a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user.*

    -  ``District``

      Select the District; from the list of districts by clicking on the arrow on the right of the selector to find users with access to a specific district. *The list will be only filled with the districts belonging to the selected region.*

    -  ``Language``

      Select the Language; from the list of languages by clicking on the arrow on the right of the selector, to select users with a specific language.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image53`).

    .. _image53:
    .. figure:: /img/user_manual/image47.png
      :align: center

      `Image 53 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the result panel.

  B. Result Panel

  .. _image54:
  .. figure:: /img/user_manual/image47.png
    :align: center

    `Image 54 - Selected record (blue), hovered records (yellow) - Result Panel`

  The result panel displays a list of all users found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image54`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image55`)

  .. _image55:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 55 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `User Page <#user-page>`__, the button panel (the buttons ``Edit`` and ``Delete``) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a user has been added, updated or deleted or if there was an error at any time during the process of these actions.

­User Page
"""""""""

  **1. Data Entry**

  .. _image56:
  .. figure:: /img/user_manual/image49.png
    :align: center

    `Image 56 - User Page`

..

    -  ``Language``

      Select the user’s preferred language from the list by clicking on the arrow on the right hand side of the lookup. Mandatory.

    -  ``Last name``

      Enter the last name (surname) for the user. Mandatory, 100 characters maximum.

    -  ``Other Names``

      Enter other names of the user. Mandatory, 100 characters maximum.

    -  ``Phone Number``

      Enter the phone number for the user. 50 characters maximum.

    -  ``Email``

      Enter the e-mail address for the user. 50 characters maximum.

    -  ``Login Name``

      Enter the Login name for the user. This is an alias used for logging into the application; a minimum of 6 and a maximum of 25 characters should be used for the login. Each Login Name should be unique. Mandatory.

    -  ``Password``

      Enter the password for the user. This is used at login to grant access to the application; a minimum of 8 and a maximum of 25 characters should be used for the password. The password should have at least one digit. Mandatory.

    -  ``Confirm Password``

      Re-enter the password. The password must be entered twice, to ensure that there was no mistyping in the first entry. Mandatory.

    -  ``Health Facility``

      Select the health facility that the user belongs to, if applicable, from the list of health Facilities from the list by clicking on the arrow on the right hand side of the lookup. *Note: The list will only be filled with the Health Facilities belonging to the districts assigned to the currently logged in user.*

    -  ``Roles``

      Select from the list of available roles the Roles which the user carries out, by either clicking on the ``Check All`` box at the top of the list of Roles, or by selectively clicking on the ``Check box`` to the left of the role. Mandatory (at least one role must be selected)

    -  ``Regions``

      Select from the list of available regions the region(s) which the user will have access to, by either clicking on the ``Check All`` box at the top of the list of regions, or by selectively clicking on the ``Check box`` to the left of a region. Mandatory (at least one region must be selected). The selection can be done indirectly by selecting a district or some districts.

    -  ``Districts``

      Select from the list of available districts the district(s) which the user will have access to, by either clicking on the ``Check All`` box at the top of the list of districts, or by selectively clicking on the ``Check box`` to the left of the district. Districts are pre-selected based on the selected region(s). The pre-selection can be modified. Mandatory (at least one district must be selected). The selection can be done indirectly by just selecting a region or some regions.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `User Control Page <#user-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the user has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data fields will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `User Control Page. <#user-control-page>`__

Adding a User
"""""""""""""

Click on the Add button to re-direct to the `User Page <#user-page>`__.

When the page opens all entry fields are empty. See the `User Page <#user-page>`__ for information on the data entry and mandatory fields.

Editing a User
""""""""""""""

Click on the Edit button to re-direct to the `User Page <#user-page>`__

The page will open with the current information loaded into the data
entry fields. See the `User Page <#user-page>`__ for information on the
data entry and mandatory fields

Deleting a User
"""""""""""""""

Click on the Delete button to delete the currently selected record

Before deleting a confirmation popup (:ref:`image57`) is displayed, this requires the user to confirm if the action should really be carried out.

.. _image57:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 57 - Delete confirmation- Button Panel`

When a user is deleted, all records retaining to the deleted user will still be available by selecting historical records.

Enrolment Officers Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enrolment Officers administration is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

An enrolment officer may only be added after the approval of the management of the scheme administration with engaging of a new enrolment officer. Editing may be done on all fields; however, approval of the management of the scheme administration is usually required for a substitution of an enrolment officer. Deletion will normally occur when an enrolment officer leaves his post within the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of enrolment officers can be found under the main menu ``Administration``, sub menu ``Enrolment Officers``.

.. _image58:
.. figure:: /img/user_manual/image50.png
  :align: center

  `Image 58 - Navigation Enrolment Officers`

Clicking on the sub menu ``Enrolment Officers`` re-directs the current user to the `Enrolment Officers Control Page. <#enrolment-officers-control-page>`__.

.. _image59:
.. figure:: /img/user_manual/image51.png
  :align: center

  `Image 59 - Enrolment Officers Control Page`

Enrolment Officers Control Page
"""""""""""""""""""""""""""""""

The Enrolment Officers Control Page is the central point for all enrolment officer administration. By having access to this page, it is possible to add, edit, delete and search. The page is divided into four panels (:ref:`image59`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of officers the following search options are available which can be used alone or in combination with each other.

    -  ``Last Name``

      Type in the beginning of; or the full ``Last name``; to search for officers with a ``Last name``, that starts with or matches completely, the typed text.

    -  ``Code``

      Type in the beginning of; or the full ``Code`` to search for officers with a ``Code, that starts with or matches completely, the typed text.

    -  ``Other Names``

      Type in the beginning of; or the full ``Other Names`` to search for officers with ``other names``, that starts with or matches completely, the typed text.

    -  ``Birth Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date From`` to search for officers having the same or later birth date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Birth Date To``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date To`` to search for officers having the same or earlier birth date. *Note: To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image60`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

      -  At anytime during the use of the pop-up, the user can see the date of *today*.
      -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
      -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
      -  Clicking on the arrow to the left displays the previous month.
      -  Clicking on the arrow on the right will displays the following month.
      -  Clicking on the month will display all the months for the year.
      -  Clicking on the year will display a year selector.

      .. _image60:
      .. |logo12| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo13| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo14| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++---------++---------+
      | |logo18| || |logo19||| |logo20||
      +----------++---------++---------+

        `Image 60 - Calendar Selector - Search Panel`

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select enrolment officers acting in a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select enrolment officers acting in a specific district. *Note: The list will be only filled with the districts belonging to the selected region and assigned to the current logged in user.*

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for enrolment officers with a Phone Number, that starts with or matches completely, the typed number.

    -  ``Email``

      Type in the beginning of; or the full ``Email`` to search for enrolment officers with the ``Email``, which starts with or matches completely, the typed text.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image61`).

    .. _image61:
    .. figure:: /img/user_manual/image52.png
      :align: center

      `Image 61 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the ``search button`` to filter the records, the results will appear in the result panel.

  B. Result Panel

  .. _image62:
  .. figure:: /img/user_manual/image53.png
    :align: center

    `Image 62  - Selected record (blue), hovered records (yellow) - Result Panel`

  The result panel displays a list of all officers found, matching the selected Criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image62`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image63`)

  .. _image63:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 63 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Enrolment Officer Page <#enrolment-officer-page>`__, the button panel (the buttons ``Edit`` and ``Delete`` is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once an officer has been added, updated or deleted or if there was an error at any time during the process of these actions.

Enrolment Officer Page
"""""""""""""""""""""""

  **1. Data Entry**

  .. _image64:
  .. figure:: /img/user_manual/image54.png
    :align: center

    `Image 64 - Enrolment Officer Page`

  ``Enrolment Officers Details``

    -  ``Code``

      Enter the code for the enrolment officer. Mandatory, 8 characters maximum.

    -  ``Last Name``

      Enter the last name (surname) for the enrolment officer. Mandatory, 100 characters maximum.

    -  ``Other Names``

      Enter other names of the enrolment officer. Mandatory, 100 characters maximum.

    -  ``Date of Birth``

      Enter the date of birth for the enrolment officer. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Phone Number``

      Enter the phone number for the enrolment officer. 50 characters maximum.

    -  ``Email``

      Enter the e-mail address for the enrolment officer. 50 characters maximum.

    -  ``Permanent Address Details``

      Enter details of the place of living of the enrolment officer.

    -  ``Region``

      Select from the list of available regions the region to a district in which the enrolment officer will act. Mandatory

    -  ``District``

      Select from the list of available districts the district in which the enrolment officer will act. `*Note: The list will be only filled with the districts belonging to the selected region.`* Mandatory .

    -  ``Substitution``

      Select from the list of available enrolment officers the enrolment officer which will substitute the current enrolment officer Substitution means that all prompts to renewals/feedback will be directed to the substituting enrolment officer. *Note: The list contains enrolment officers who already exist in the system and who have at least on location common with the enrolment officer to be substituted.*

    -  ``Works To``

      Enter the date which the substituted enrolment officer will work up to. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Communicate``

      Check the box ``Communicate`` if the enrolment officer should receive SMS messages alerting him/her about a need of renewing policies of families/groups he/she is assigned to.

    -  ``Municipalities``

      Select from the list of available municipalities the municipality(s) which the enrolment officer is acting in, by either clicking on the ``Check All`` box at the top of the list of municipalities, or by selectively clicking on the ``Check box`` to the left of the municipality. Mandatory (at least one municipality must be selected.

    -  ``Villages``

      Select from the list of available villages the village(s) which the enrolment officer is acting in, by either clicking on the ``Check All`` box at the top of the list of villages, or by selectively clicking on the ``Check box`` to the left of the village. Villages are pre-selected based on the selected municipality. The pre-selection can be modified. Mandatory (at least one village must be selected.

  ``village Officer Details``

    -  ``Code``

      Enter the code for the Village Executive officer. 25 characters maximum.

    -  ``Last name``

      Enter the last name (surname) for the Village Executive officer. 100 characters maximum.

    -  ``Other Names``

      Enter other names of the Village Executive officer. 100 characters maximum.

    -  ``Phone Number``

      Enter the phone number for the Village Executive officer. 25 characters maximum.

    -  ``Email``

      Enter the e-mail address for the Village Executive officer. 50 characters maximum.

    -  ``Date of Birth``

      Enter the date of birth for the Village Executive officer. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Enrolment Officers Control Page <#enrolment-officers-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the officer has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

   By clicking on the ``Cancel`` button, the user will be re-directed to the `Enrolment Officers Control Page <#enrolment-officers-control-page>`__.

Adding an Enrolment Officer
"""""""""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Enrolment Officer Page <#enrolment-officer-page>`__\ .

When the page opens all entry fields are empty. See the `Enrolment Officer Page <#enrolment-officer-page>`__ for information on the data entry and mandatory fields

Editing an Enrolment Officer
""""""""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Enrolment Officer Page <#enrolment-officer-page>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Enrolment Officer Page <#enrolment-officer-page>`__ for information on the data entry and manditory fields.

Deleting an Enrolment Officer
"""""""""""""""""""""""""""""

Click on the ``Delete`` button to delete the currently selected record.

Before deleting a confirmation popup (:ref:`image65`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image65:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 65 - Delete confirmation- Button Panel`

When an officer is deleted, all records retaining to the deleted officer will still be available by selecting historical records.

Claim Administrators Administration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register contains employees of contractual health facilities responsible for preparation and/or submission of claims. Administration of the register of claim administrators is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A claim administrator may be added after the agreement of a contractual health facility and the management of the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of claim administrators can be found under the main menu ``Administration``, submenu ``Claim Administrators``.

.. _image66:
.. figure:: /img/user_manual/image60.png
  :align: center

  `Image 66 - Navigation Claim Administrators`

Clicking on the sub menu ``Claim Administrators`` re-directs the current user to the `Claim Administrators Control Page. <#claim-administrators-control-page>`__

.. _image67:
.. figure:: /img/user_manual/image56.png
  :align: center

  `Image 67 - Claim Administrators Control Page`

Claim Administrators Control Page
"""""""""""""""""""""""""""""""""

The ``Claim Administrators Control Page`` is the central point for all claim administrators administration. By having access to this panel, it is possible to add, edit, delete and search claim administrators. The panel is divided into four panels (:ref:`image67`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of claim administrators the following search options are available which can be used alone or in combination with each other.

    -  ``Last Name``

      Type in the beginning of; or the full ``Last name``; to search for claim administrator with a ``Last name``, which starts with or matches completely, the typed text.

    -  ``Code``

      Type in the beginning of; or the full ``Code`` to search for claim administrator with a ``Code``, which starts with or matches completely, the typed text.

    -  ``Other Names``

      Type in the beginning of; or the full ``Other Names`` to search for claim administrator with ``Other Names`` which starts with or matches completely, the typed text.

    -  ``Birth Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date From`` to search for claim administrators having the same or later birth date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Birth Date To``

      Type in a date; or use the Date Selector Button, to enter the Birth Date To to search for claim administrators having the same or earlier birth date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image68`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

      -  At any time during the use of the pop-up, the user can see the date of *today*.
      -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
      -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
      -  Clicking on the arrow to the left displays the previous month.
      -  Clicking on the arrow on the right will displays the following month.
      -  Clicking on the month will display all the months for the year.
      -  Clicking on the year will display a year selector.

      .. _image68:
      .. |logo21| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo22| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo23| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo20| || |logo21| || |logo22 ||
      +----------++----------++----------+

        `Image 68 - Calendar Selector - Search Panel`

    -  ``HF Code``

      Select ``HF Code`` (a health facility code); from the list of health facility codes by clicking on the arrow on the right of the selector to select claim administrators from a specific health facility. *Note: The list will only be filled with the health facilities from districts which are assigned to the current logged in user.*

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for claim administrators with a ``Phone Number``, which starts with or matches completely, the typed number.

    -  ``Email``

      Type in the beginning of; or the full ``email`` to search for claim administrators with an e-mail\ , which starts with or matches completely, the typed text.

    -  ``Historical ``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image69`).

    .. _image69:
    .. figure:: /img/user_manual/image57.png
      :align: center

      `Image 69 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The Result Panel displays a list of all claim administrators found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image70`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image70:
  .. figure:: /img/user_manual/image58.png
    :align: center

    `Image 70 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image71`)

  .. _image71:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 71 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Claim Administrator Page <#claim-administrator-page>`__, the button panel (the buttons ``Edit`` and ``Delete``) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once an officer has been added, updated or deleted or if there was an error at any time during the process of these actions.

Claim Administrator Page
""""""""""""""""""""""""

  **1. Data Entry**

  .. _image72:
  .. figure:: /img/user_manual/image59.png
    :align: center

    `Image 72 - Claim Administrator Page`

  ``claim administrator details``

    -  ``Code``

      Enter the code for the claim administrator. Mandatory, 8 characters maximum.

    -  ``Last name``

      Enter the last name (surname) for the claim administrator. Mandatory, 100 characters maximum.

    -  ``Other Names``

      Enter other names of the claim administrator. Mandatory, 100 characters maximum.

    -  ``Date of Birth``

      Enter the date of birth for the claim administrator. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Phone Number``

      Enter the phone number for the claim administrator. 50 characters maximum.

    -  ``Email``

      Enter the e-mail for the claim administrator. 50 characters maximum.

    -  ``HF Code``

      Select from the list of available health facilities the health facility which the claim administrator will have access to and will act for. Mandatory.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Claim Administrators Control Page <#claim-administrators-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the claim administrator has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right side of the corresponding field).

  **4. Cancel**

  By clicking on the Cancel button, the user will be re-directed to the `Claim Administrators Control Page <#claim-administrators-control-page>`__.

Adding a Claim Administrator
""""""""""""""""""""""""""""

Click on the ``Add`` button to re-direct to the `Claim Administrator Page <#claim-administrator-page>`__\ .

When the page opens all entry fields are empty. See the `Claim Administrator Page <#claim-administrator-page>`__ for information on the data entry and mandatory fields

Editing a Claim Administrator
"""""""""""""""""""""""""""""

Click on the ``Edit`` button to re-direct to the `Claim Administrator Page <#claim-administrator-page>`__\ ..

The page will open with the current information loaded into the data entry fields. See the `Claim Administrator Page <#claim-administrator-page>`__ for information on the data entry and mandatory fields

Deleting a Claim Administrator
""""""""""""""""""""""""""""""

Click on the ``Delete`` button to delete the currently selected record

Before deleting a confirmation popup (:ref:`image73`) is displayed, which requires the user to confirm if the action should really be carried out.

.. _image73:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 73 - Delete confirmation- Button Panel`

When a claim administrator is deleted, all records retaining to the deleted claim administrator will still be available by selecting historical records.

Payers Administration
^^^^^^^^^^^^^^^^^^^^^

The register of payers contains all institutional payers that can pay contributions on behalf of policy holders (e.g. private organizations, local authorities, cooperatives etc.). Payer administration is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A payer may only be added or thereafter edited or deleted, after the approval of the management of the scheme administration.

Navigation
~~~~~~~~~~

.. _image74:
.. figure:: /img/user_manual/image60.png
  :align: center

  `Image 74 - Navigation Payers`

All functionality for use with the administration of payers can be found under the main menu ``Administration``, sub menu ``Payers.``

.. _image75:
.. figure:: /img/user_manual/image61.png
  :align: center

  `Image 75 - Payers Control Page`

Clicking on the sub menu ``Payers`` re-directs the current user to the `Payer Control Page <#payer-control-page>`__\.

Payer Control Page
~~~~~~~~~~~~~~~~~~

The Payer control Page is the central point for all payer administration. By having access to this page, it is possible to add, edit, delete and search (institutional) payers. The page is divided into four panels (:ref:`image75`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of payers the following search options are available which can be used alone or in combination with each other.

    -  ``Name``

      Type in the beginning of; or the full ``name``; to search for payers with a ``name``, that starts with or matches completely, the typed text.

    -  ``Email``

      Type in the beginning of; or the full ``Email`` to search for payers with an ``Email``, that starts with or matches completely, the typed text.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select payers from a specific region. The option **National** means that the payer is common for all regions. *Note: The list will only be filled with the regions assigned to the current logged in user and with the option National. All nationwide payers and all regional payers relating to the selected region will be found. If no district is selected then also all district payers for districts belonging to the selected region will be found.*

    -  ``District``

      Select the ``district``; from the list of districts by clicking on the arrow on the right of the selector to select payers from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the currently logged in user. If this is only one then the district will be automatically selected*

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for payers with a ``Phone Number``, that starts with or matches completely, the typed number.

    -  ``Type``

      Select the ``Type``; from the list of types of payers by clicking on the arrow on the right of the selector to select payers of specific type.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image76`).

    .. _image76:
    .. figure:: /img/user_manual/image62.png
      :align: center

      `Image 76 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the result panel.

  B. Result Panel

  .. _image77:
  .. figure:: /img/user_manual/image63.png
    :align: center

    `Image 77 - Selected record (blue), hovered records (yellow) - Result Panel`

  The result panel displays a list of all payers found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image77`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image78`).

  .. _image78:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 78 - Page selector- Result Panel`

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Payer Page <#payer-page>`__, the button panel (the buttons ``Edit`` and ``Delete``) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a payer has been added, updated or deleted or if there was an error at any time during the process of these actions.

Payer Page
~~~~~~~~~~

  **1. Data Entry**

  .. _image78:
  .. figure:: /img/user_manual/image64.png
    :align: center

    `Image 78 - Payer Page`

..

    -  ``Type``

      Select the type of the payer from the list by clicking on the arrow on the right hand side of the lookup. Mandatory.

    -  ``Name``

      Enter the name for the payer. Mandatory, 100 characters maximum.

    -  ``Address``

      Enter address of the payer. Mandatory, 100 characters maximum.

    -  ``Phone Number``

      Enter the phone number for the payer. 50 characters maximum.

    -  ``Fax``

      Enter the fax number for the payer. 50 characters maximum.

    -  ``Email``

      Enter the email for the payer. 50 characters maximum.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to enter the region to which the payer belongs. The region **National** means that the payer is common for all regions. *Note: The list will only be filled with the regions assigned to the current logged in user and with the option National.* Mandatory.

    -  ``District``

      Select the ``district`` to which the payer belongs, from the list by clicking on the arrow on the right hand side of the lookup. *Note: The list will only be filled with the districts assigned to the selected region and currently logged in user. If this is only one then the district will be automatically selected.* It is not mandatory to enter a district. Not selecting a district will mean the payer operates in all districts of the region or nationwide if the region National is selected.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Payer Control Page <#payer-control-page>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the payer has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right of the corresponding data field).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Payer Control Page <#payer-control-page>`__.

Adding a Payer
~~~~~~~~~~~~~~

Click on the ``Add`` button to re-direct to the `Payer Page <#payer-page>`__\ .

When the page opens all entry fields are empty. See the `Payer Page <#payer-page>`__ for information on the data entry and mandatory fields.

Editing a Payer
~~~~~~~~~~~~~~~

Click on the ``Edit`` button to re-direct to the `Payer Page <#payer-page>`__\ .

The page will open with the current information loaded into the data entry fields. See the `Payer Page <#payer-page>`__ for information on the data entry and mandatory fields.

Deleting a Payer
~~~~~~~~~~~~~~~~

Click on the Delete button to delete the currently selected record.

Before deleting a confirmation popup (:ref:`image79`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image79:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 79 - Delete confirmation- Button Panel`

When a payer is deleted, all records retaining to the deleted payer will still be available by selecting historical records.

Locations Administration
^^^^^^^^^^^^^^^^^^^^^^^^

Administration of locations is restricted to users with the role of Scheme Administrator.

Pre-conditions
""""""""""""""

A region, district, municipality or village may only be added or thereafter edited, after the approval of the management of the scheme administration.

Navigation
""""""""""

All functionality for use with the administration of locations can be found under the main menu ``Administration``, sub menu ``Locations.``

.. _image80:
.. figure:: /img/user_manual/image65.png
  :align: center

  `Image 80 - Navigation Locations`

Clicking on the sub menu ``Locations`` re-directs the current user to the `Locations Page. <#locations-page>`__

.. _image81:
.. figure:: /img/user_manual/image66.png
  :align: center

  `Image 81 - Locations Page`

Locations Page
""""""""""""""

The Locations page is the central point for all locations administration. By having access to this page, it is possible to add, edit, delete and move regions, districts, municipalities and villages. The page is divided into three panels (:ref:`image81`). *Note. Only regions and districts with associated municipalities and villages, belonging to the logged in user will be available to edit or delete. On adding a new region or district, the user will automatically become associated with this region or district.*

  A. Locations Panel

  This is the working panel and is divided into four vertical panels of ``Regions, Districts, Municipalities`` and ``Villages.``

  B. Button Panel

  It has four buttons, ``Add``, ``Edit``, ``Delete`` and ``Move`` for actions on the locations and the ``Cancel`` button for re-directing to the `Home Page <#image-2.2-home-page>`__\.

  .. _image82:
  .. figure:: /img/user_manual/image67.png
    :align: center

    `Image 82 - Action Buttons - Locations Page`

  C. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a region, district or municipality or village has been added, updated, moved or deleted or if there was an error at any time during the process of these actions.

  **1. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Home Page <#image-2.2-home-page>`__\ .

Adding a Region, District, Municipality, Village
""""""""""""""""""""""""""""""""""""""""""""""""

Focusing on the appropriate level of locations by clicking on the black or the empty bar on the top of the appropriate panel and clicking on the ``Add`` button will open up in the top of the screen an empty entry box. Here one could enter the new code (**Code**) and name (**Name**) of a region, district, municipality or village. For villages, the number of male inhabitants (**M**), female inhabitants (**F**), inhabitants with the unspecified gender (**O**) and the number of families (**Fam.**) can be specified. On clicking the ``Save`` button the new record will be saved.

Editing a Region, District, Municipality, Village
"""""""""""""""""""""""""""""""""""""""""""""""""

Selecting the location to edit and clicking on the ``Edit`` button will open up in the top of the screen an entry box with the name of the location. Here one could change the name. On clicking the ``Save`` button, the record will be saved.

Deleting a Region, District, Municipality, Village
""""""""""""""""""""""""""""""""""""""""""""""""""

Select first the location to delete and click the ``Delete`` button. *Note. It is not possible to delete a region, district or municipality with associated districts, municipalities or villages respectively.*

Before deleting a confirmation popup (:ref:`image83`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image83:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 83 - Delete confirmation – Location Page`

When a region, district, municipality or village is deleted, all records retaining to the deleted region, district, municipality or village will still be available by selecting historical records.

Moving a District, Municipality, Village
""""""""""""""""""""""""""""""""""""""""

Moving of a location is needed when the administrative division of the territory, on which a health insurance scheme is active, changes. Clicking on the ``Move`` button will re-direct to the Move Location Page (:ref:`image84`).

.. _image84:
.. figure:: /img/user_manual/image68.png
  :align: center

   `Image 84 - Move Location Page`

The ``Move Location Page`` is divided into six panels.

  A. Locations Panels (A,B,C,D)

  The pair of A and B panels is used for moving of a village to another municipality. The pair of B and C panels is used for moving of a municipality to another district. The pair C and D is used for moving a district to another region.

  For moving a location, select a location (village, municipality, district) in two adjacent panels by selecting of higher level locations in the fields ``Region, District, Municipality`` and clicking on the selected location (village, municipality, district) in a panel and on a new parent location in the next panel.

  Actual moving of a location into a new parent locations is done by clicking on the green arrow between the two corresponding location panels.

  E. Button Panel

  It has only the ``Cancel`` button for re-directing to the `Location Page <#locations-page>`__.

  F. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a district, municipality or village has been moved or if there was an error at any time during the process of this action.

Insurees and Policies
---------------------

Insuree Enquiry
^^^^^^^^^^^^^^^^

This functionality is available to users will all roles. The function Insuree Enquiry can be accessed at any time, after login. On the top right hand of the main menu, there is a search feature, allowing the user to enter an Insurance Number for a “quick enquiry”.

.. _image85:
.. figure:: /img/user_manual/image69.png
  :align: center

  `Image 85 - Insuree Enquiry Field`

By typing in a valid insurance­­­­­­­ number and pressing the enter key or clicking on the green search button, a pop-up will appear (:ref:`image86`), providing a photo of the insuree and information about the current policy or policies covering of the insuree.

The Information includes the following:

  -  The photo of the insuree
  -  The name, date of birth and gender of the insuree
  -  The (insurance) product code, product name and expiry date of a policy
  -  The status (I for Idle, A for Active, S for Suspended and E for Expired) of the policy at the time of inquiring
  -  The deductible amount remaining for the insuree to pay before the policy is claimable, for hospitals and non-hospitals
  -  The ceiling amount claimable by a health facility on behalf of the insuree for both hospitals and non-hospitals.

.. _image86:
.. figure:: /img/user_manual/image70.png
  :align: center

  `Image 86 - Insuree Enquiry Results`

Find Family
^^^^^^^^^^^

Access to the ``Find Family Page`` is restricted to users with the role of Accountant, Clerk and Health Facility Receptionist.

Pre-conditions
""""""""""""""

Need to enquire on, or edit a family and/or insurees, policies and contributions associated.

Navigation
""""""""""

Find Family can be found under the main menu ``Insurees and Policies`` sub menu ``Families/Groups``

.. _image87:
.. figure:: /img/user_manual/image71.png
  :align: center

  `Image 87 - Navigation – Families - Find Family`

Clicking on the sub menu ``Families/Groups`` re-directs the current user to the `Find Family Page <#find-family-page>`__\.

.. _image88:
.. figure:: /img/user_manual/image72.png
  :align: center

  `Image 88 - Find Families`

The Find Family Page is the first step in the process of finding of a family and thereafter accessing the `Family Overview Page <#family-overview>`__ of insurees, policies and contributions. This initial page can be used to search for specific families or groups based on specific criteria. The page is divided into four panels (:ref:`image88`):

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. The following search options are available which can be used alone or in combination with each other.

    -  ``Last Name``

      Type in the beginning of; or the full ``Last name``; to search for families/groups, who’s family head/group head ``Last name``, starts with or matches completely, the typed text.

    -  ``Other Names``

      Type in the beginning of; or the full ``Other Names`` to search for families/groups, who’s family head/group head ``Other Names`` starts with or matches completely, the typed text.

    -  ``Insurance Number``

      Type in the beginning of; or the full ``Insurance Number`` to search for families/groups, who’s family head/group head ``Insurance Number``, starts with or matches completely, the typed text.

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for families/groups, who’s family head/group head ``Phone Number``, starts with or matches completely, the typed number.

    -  ``Birth Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date From`` to search for families/groups, who’s family head/group head, has the same or later birth date than ``Birth Date From``. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Birth Date To``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date To`` to search for families/groups, who’s family head/group head, has the same or earlier birth date than ``Birth Date To``. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image89`) by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of *today*.
        -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image89:
      .. |logo23| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo24| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo25| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo23| || |logo24| || |logo25| |
      +----------++----------++----------+

        `Image 89 - Calendar Selector - Search Panel`

    -  ``Gender``

      Select the ``Gender``; from the list of gender by clicking on the arrow on the right of the selector, to select families/groups, who’s family head/group head is of the specific gender.


    -   ``Poverty Status``

      Select the ``Poverty Status``; from the list of has poverty status by clicking on the arrow on the right of the selector, to select families/groups that have a specific poverty status.

    -  ``Email``

      Type in the beginning of; or the full ``Email`` to search for families/groups, who’s family head/group head ``Email`` starts with or matches completely the typed text.

    -  ``Confirmation Type``

      Type in the beginning of; or the full ``Confirmation Type`` to search for families/groups, who’s ``Confirmation Type``. starts with or matches completely the typed text.

    -  ``Confirmation No.``

      Type in the beginning of; or the full ``Confirmation No.`` to search for families/groups, who’s ``Confirmation No.`` starts with or matches completely the typed text.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select families/groups from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select families/groups from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``Municipality``

      Select the ``Municipality``; from the list of municipalities by clicking on the arrow on the right of the selector to select families/groups from a specific municipality. *Note: The list will only be filled with the municipalities in the selected district above.*


      Select the ``Village``; from the list of villages by clicking on the arrow on the right of the selector to select families/groups from a specific village. *Note: The list will only be filled with the villages in the selected municipality above.*

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image90`).


    .. _image90:
    .. figure:: /img/user_manual/image73.png
      :align: center

      `Image 90 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  .. _image91:
  .. figure:: /img/user_manual/image74.png
    :align: center

    `Image 91 - Selected record (blue), hovered records (yellow) - Result Panel`

  The Result Panel displays a list of all families/groups found, matching the selected criteria in the Search Panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image91`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the `Family Overview Page <#family-overview>`__ for the Family selected or if it is an historical record then the `Change Family Page <#familygroup-page>`__, for detailed viewing.

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image92`)

  .. _image92:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 92 - Page selector- Result Panel`

  C. Button Panel

  The ``Cancel`` button re-directs to the `Home Page <#image-2.2-home-page>`__.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a family/group has been added, updated or deleted or if there was an error at any time during the process of these actions.

Find Insuree
^^^^^^^^^^^^

Access to the Find Insuree Page is restricted to users with the role of Accountant, Clerk and Health Facility Receptionist.

Pre-conditions
""""""""""""""

Need to enquire on, or edit an insuree, and the family/group, policies and contributions associated.

Navigation
""""""""""

All functionality for use with the administration of insurees can be found under the main menu ``Insurees and Policies``, sub menu ``Insurees``.

.. _image93:
.. figure:: /img/user_manual/image75.png
  :align: center

  `Image 93 - Navigation Insurees`

Clicking on the sub menu ``Insurees`` re-directs the current user to the Find Insuree Page.\

Find Insuree Page
"""""""""""""""""

.. _image94:
.. figure:: /img/user_manual/image76.png
  :align: center

  `Image 94 - Find Insuree Page`

The ``Find Insuree Page`` is the first step in the process of finding an insuree and thereafter accessing the family/group overview of insurees, policies and contributions. This initial page can be used to search for specific Insurees or groups of insurees based on specific criteria. The panel is divided into four panels (:ref:`image94`)

  A. Search Panel

  The Search Panel allows a user to select specific criteria to minimise the search results. In the case of insurees the following search options are available, which can be used alone or in combination with each other.

    -  ``Last Name``

      Type in the beginning of; or the full ``Last name``; to search for insurees with a ``Last name``, which starts with or matches completely, the typed text.

    -  ``Other Names``

      Type in the beginning of; or the full ``Other Names`` to search for insurees with ``Other Names`` which starts with or matches completely, the typed text.

    -  ``Insurance Number``

      Type in the beginning of; or the full ``Insurance Number`` to search for insurees with the ``Insurance Number``, which starts with or matches completely, the typed text.

    -  ``Marital Status``

      Select the ``Marital Status``; from the list of marital status by clicking on the arrow on the right of the selector, to select insurees of a specific marital status.

    -  ``Phone Number``

      Type in the beginning of; or the full ``Phone Number`` to search for insurees with a ``Phone Number``, which starts with or matches completely, the typed number.

    -  ``Birth Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date From`` to search for insurees who have the same or later birth date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Birth Date To``

      Type in a date; or use the Date Selector Button, to enter the ``Birth Date To`` to search for insurees who have the same or earlier birth date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image95`) by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of *today*.
        -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image95:
      .. |logo26| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo27| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo28| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo26| || |logo27| || |logo28| |
      +----------++----------++----------+

        `Image 95 - Calendar Selector - Search Panel`

    -  ``Gender``

      Select the ``Gender``; from the list of genders by clicking on the arrow on the right of the selector, to select insurees of a specific gender.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select insurees from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select insurees from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``Municipality``

      Select the ``Municipality``; from the list of wards by clicking on the arrow on the right of the selector to select insurees from a specific municipality. *Note: The list will only be filled with the wards in the selected district above.*

    -  ``Village``

      Select the ``Village``; from the list of villages by clicking on the arrow on the right of the selector to select insurees from a specific village. *Note: The list will only be filled with the villages in the selected municipality above.*

    -  ``Photo Assigned``

      Select whether all insurees are searched [**All**] or only insurees with a photo assigned [**Yes**] or only insurees with no photo assigned [**No**].

    -  ``Historical``

      Click on Historical to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image96`)

    .. _image96:
    .. figure:: /img/user_manual/image77.png
      :align: center

      `Image 96 - Historical records - Result Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The result panel displays a list of all Insurees found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image97`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the `Family Overview Page <#family-overview-page.>`__ of the insuree’s family, or the `Insuree Page <#insuree-page>`__ if it is a historical record for viewing purposes.

  .. _image97:
  .. figure:: /img/user_manual/image78.png
    :align: center

    `Image 97 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image98`)

  .. _image98:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 98 - Page selector- Result Panel`

  C. Button Panel

  The ``Cancel`` button re-directs to the ``Home Page``.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a insuree has been added, updated or deleted or if there was an error at any time during the process of these actions.

Find Policy
^^^^^^^^^^^^

Access to the ``Find Policy Page`` is restricted to users with the role of Accountant, Clerk or Health Facility Receptionist.

Pre-conditions
""""""""""""""

Need to enquire on, or edit a policy, and the family/group, insurees and contributions associated.

Navigation
""""""""""

Find Policy Page can be found under the main menu ``Insurees and Policies``, sub menu ``Policies``.

.. _image99:
.. figure:: /img/user_manual/image79.png
  :align: center

  `Image 99 - Navigation Policies`

Clicking on the sub menu ``Policies`` re-directs the current user to the ``find policy page.``

Find Policy Page
""""""""""""""""

.. _image100:
.. figure:: /img/user_manual/image80.png
  :align: center

  `Image 100 - Find Policy Page`

The ``Find Policy Page`` is the first step in the process of finding a policy and thereafter accessing the `Family Overview Page <#family-overview-page.>`__ of insurees, policies and contributions. This initial page can be used to search for specific policies or groups of policies based on specific criteria. The panel is divided into four panels (:ref:`image100`)

  A. Search Panel

  The Search Panel allows a user to select specific criteria to minimise the search results. In the case of policies the following search options are available which can be used alone or in combination with each other.

    -  ``Enrolment Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Enrolment Date From`` to search for policies with an ``Enrolment Date`` equal or later than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Enrolment Date To``

      Type in a date; or use the Date Selector Button, to enter the ``Enrolment Date to`` to search for policies with an ``Enrolment Date`` equal or earlier than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Effective Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Effective Date From`` to search for policies with an ``Effective Date`` equal or later than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Effective Date To``

      Type in a date; or use the Date Selector Button, to enter the ^^Effective Date To'' to search for policies with an ^^Effective Date^^ equal or earlier than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Start Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Start Date From`` to search for policies with a ``Start Date`` equal or later than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Start Date To``

      Type in a date; or use the Date Selector Button, to enter the ``Start Date to`` to search for policies with a ``Start Date`` equal or earlier than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Expiry Date From``

      Type in a date; or use the Date Selector Button, to enter the ``Expiry Date From`` to search for policies with an ``Expiry Date`` equal or later then the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image101`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of *today*.
        -  Clicking on **today** will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image101:
      .. |logo27| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo28| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo29| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo27| || |logo28| || |logo29| |
      +----------++----------++----------+

        `Image 101 - Calendar Selector - Search Panel`

    -  ``Enrolment Officer``

      Select the ``Enrolment Officer``; from the list of enrolment officers by clicking on the arrow on the right of the selector, to select policies related to a specific enrolment officer.

    -  ``Product``

      Select the ``Product``; from the list of products by clicking on the arrow on the right of the selector, to select policies for a specific product.

    -  ``Policy Status``

      Select the ``Policy Status``; from the list of policy statuses by clicking on the arrow on the right of the selector, to select policies for a specific policy status.

      A policy can have the following statuses:

        -  **Idle** (Policy data entered but policy not yet activated)
        -  **Active** (Policy partially or fully paid and made active)
        -  **Suspended** (Policy was not fully paid for within the grace period)
        -  **Expired** (Policy is not active anymore as the insurance period elapsed)
s
    -  ``Balance``

      Types in a positive ``Balance`` to search for policies with a balance equal or greater than the typed amount. For example if 0 (zero) is entered, all policies with a balance, will be displayed. If 1,000 is entered, then only policies with a balance equal to or greater than 1,000 will be displayed.

      The balance is the difference between the policy value and total of contributions paid. For the policy

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select policies from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select policies for families/groups residing in a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``Policy Type``

      Select whether new policies [New Policy] or renewed policies [Renewal] should be searched for.

    -  ``Inactive Insurees``

      Check the box to select only policies for families/groups with insurees which are non-active (not covered) despite the policy of their family/group is active. The reason may be addition of a new insuree (member) to the family/group with an active policy without adequate payment of additional contributions or because the maximum number of members in the family/group exceeds the maximum number determined by the insurance product of the policy.

    -  ``Historical``

      Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image102`)

    .. _image102:
    .. figure:: /img/user_manual/image81.png
      :align: center

      `Image 102 - Historical records - Result Panel`

    -  ``Search button``

      Once the criteria have been entered, use the ``Search`` button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The Result Panel displays a list of all policies found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image103`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image103:
  .. figure:: /img/user_manual/image82.png
    :align: center

    `Image 103 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (`Image104 <#image-4.20-page-selector--result-panel>`__)

  .. _image104:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 104 - Page selector- Result Panel`

  C. Button Panel

  The ``Cancel`` button re-directs to the `Home Page <#image-2.2-home-page>`__.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a policy has been added, updated or deleted or if there was an error at any time during the process of these actions.

Find Contribution
^^^^^^^^^^^^^^^^^

Access to the Find Contribution Page is restricted to users with the role of Accountant or Clerk.

Pre-conditions
""""""""""""""

Need to enquire on, or edit a contribution, or the family/group, insurees and policies associated.

Navigation
""""""""""

Find Contribution can be found under the main menu ``Insurees and Policies``, sub menu ``Contributions``

.. _image105:
.. figure:: /img/user_manual/image83.png
  :align: center

 `Image 105 - Navigation Contributions`

Clicking on the sub menu ``Contributions`` re-directs the current user to the `Find Contribution Page <#_Image_4.22_(Find>`__\.

Find Contribution Page
""""""""""""""""""""""

.. _image106:
.. figure:: /img/user_manual/image84.png
  :align: center

 `Image - 106 Find Contribution Page`

The ``Find Contribution Page`` is the first step in the process of finding a contribution and thereafter accessing the `Family Overview Page <#family-overview>`__ of insures, policies and contributions. This initial page can be used to search for specific contributions or groups of contributions based on specific criteria. The page is divided into four panels (:ref:`image106`).

    A. Search Panel

    The Search Panel allows a user to select specific criteria to minimise the search results. In the case of contributions the following search options are available which can be used alone or in combination with each other.

      -  ``Payer``

        Select the ``Payer``; from the list of payers by clicking on the arrow on the right of the selector, to select contributions related to a specific payer.

      -  ``Payment Type``

        Select the ``Payment Type``; from the list of types by clicking on the arrow on the right of the selector, to select contributions related to a specific payment type.

      -  ``Payment Date From``

        Type in a date; or use the Date Selector Button, to enter the ``Payment Date From`` to search for contributions with a ``Payment Date`` equal or later than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

      -  ``Payment Date To``

        Type in a date; or use the Date Selector Button, to enter the ``Payment Date To`` to search for contributions with a ``Payment Date`` equal or earlier than the specified date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

      -  ``Date Selector Button``

        Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image107`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

          -  At anytime during the use of the pop-up, the user can see the date of *today*.
          -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
          -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
          -  Clicking on the arrow to the left displays the previous month.
          -  Clicking on the arrow on the right will displays the following month.
          -  Clicking on the month will display all the months for the year.
          -  Clicking on the year will display a year selector.

        .. _image107:
        .. |logo30| image:: /img/user_manual/image6.png
          :scale: 100%
          :align: middle
        .. |logo31| image:: /img/user_manual/image7.png
          :scale: 100%
          :align: middle
        .. |logo32| image:: /img/user_manual/image8.png
          :scale: 100%
          :align: middle

        +----------++----------++----------+
        | |logo30| || |logo31| || |logo32| |
        +----------++----------++----------+

          `Image 107 - Calendar Selector - Search Panel`

      -  ``Contribution Paid``

        Type in the ``Contribution Paid`` to search for contributions with the paid amount, greater or equal to the typed amount.

      -  ``Region``

        Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select contributions for policies from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

      -  ``District``

        Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select contributions paid for policies from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

      -  ``Historical``

        Click on ``Historical`` to see historical records matching the selected criteria. Historical records are displayed in the result with a line through the middle of the text (strikethrough) to clearly define them from current records (:ref:`image108`).

      .. _image108:
      .. figure:: /img/user_manual/image85.png
        :align: center

        `Image 108 - Historical records - Result Panel`

      -  ``Search Button``

      Once the criteria have been entered, use the ``Search`` button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The result panel displays a list of all contributions found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image109`) The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image109:
  .. figure:: /img/user_manual/image86.png
    :align: center

    `Image 109 Selected record (blue), hovered records (yellow) - Result Pane`

  A maximum of 15 records are displayed at one time, further records can be viewed by navigating through the pages using the page selector at the bottom of the result Panel (:ref:`image110`).

  .. _image110:
  .. figure:: /img/user_manual/image11.png
    :align: center

    `Image 110 - Page selector- Result Panel`

  C. Button Panel

  The ``Cancel`` button re-directs to the `Home Page <#image-2.2-home-page>`__.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a contribution has been added, updated or deleted or if there was an error at any time during the process of these actions.

Family Overview
^^^^^^^^^^^^^^^

Access to the `Family Overview Page <#family-overview-page.>`__ is restricted to users with the role of Accountant or Clerk.

Pre-conditions
""""""""""""""

Need to enquire on, or edit a family/group or manage the insurees, policies and contributions associated with it.

.. _navigation-15:

Navigation
""""""""""

`Family Overview Page <#family-overview-page.>`__ cannot be navigated directly to; the first step is to find the family/group by means of using `Find Family Page <#find-family-page>`__, `Find Insuree Page <#_Image_4.10_(Find>`__, `Find Policy Page <#_Image_4.16_(Find>`__ or `Find Contribution Page <#_Image_4.22_(Find>`__. Once a specific family, insuree, policy or contribution is selected by means of selecting the hyperlink in the Result Panel of the respective Find Page, the user is re-directed to the `Family Overview Page <#family-overview-page.>`__.

Family Overview Page
""""""""""""""""""""

.. _image111:
.. figure:: /img/user_manual/image87.png
  :align: center

  `Image 111 - Family Overview Page`

The ``Family Overview Page`` is the central point for all operations with regards to the families/groups, Insurees, policies and contributions associated with it. The page is divided into 6 panels `(Image111) <#image-4.27-family-overview-page>`__

  A. Family/Group Panel

  The Family/Group Panel provides information about the family including the Insurance Number and the Last Name and Other Names of the head of family and the District, Municipality, Village and Poverty status of the family. In the Family/Group panel action buttons allow to add, edit and delete the family/group.

  .. _image112:
  .. figure:: /img/user_manual/image88.png
    :align: center

..

    The ``green plus sign`` is for adding a new family/group.

    The ``yellow pencil sign`` is for editing a family/group.

    The ``red cross sign`` is for deleting a family/group.

  B. Insurees Panel

  The Insurees Panel displays a list of the insurees within the family/group. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image113`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the insuree record for editing or detailed viewing.

  .. _image113:
  .. figure:: /img/user_manual/image89.png
    :align: center

    `Image 113 - Selected record (blue), hovered records (yellow) – Insurees Panel`


  In the Insurees Panel, action buttons allow to add, edit and delete insurees belonging to the family/group.

  .. _image114:
  .. figure:: /img/user_manual/image90.png
    :align: center

..

    The ``green plus sign`` is for adding a new insuree.

    The ``yellow pencil sign`` is for editing an insuree.

    The ``red cross sign`` is for deleting an insuree.

  C. Policies Panel

  The Policies Panel displays a list of the policies held by the family/group. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image115`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the policy for editing or detailed viewing. By default the first policy is selected and therefore in the Contribution Panel, only the contributions paid on that policy will be displayed in the Contribution Panel By selecting another policy in the list, the Contribution Panel, will refresh with the contributions paid on the newly selected policy.

  .. _image115:
  .. figure:: /img/user_manual/image91.png
    :align: center

    `Image 115 - Selected record (blue), hovered records (yellow) - Policy Panel`

  In the fifth **Product** column of Policy data grid, there is a link showing product for the policy on the corresponding row. When the link is clicked; a popup browser window `(Image116) <#image-4.30-product-popup-policies-panel>`__ will open up showing the details of the product (in read-only mode).

  .. _image116:
  .. figure:: /img/user_manual/image92.png
    :align: center

    `Image 116 - Product Popup – Policies Panell`

  In the ``Policies Panel``, action buttons allow to add, edit and delete policies.

  .. _image117:
  .. figure:: /img/user_manual/image93.png
    :align: center

..

    The ``green plus sign`` is for adding a new policy.

    The ``yellow pencil sign`` is for editing a policy.

    The ``red cross sign`` is for deleting a policy.

    The ``blue R sign`` is for renewing a policy.

  D. Contributions Panel

  The ``Contribution Panel`` displays a list of contributions paid on the policy currently selected in the ``Policies Panel``. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image118`) The leftmost record contains a hyperlink which if clicked, re-directs the user to the contribution for editing or detailed viewing.

  .. _image118:
  .. figure:: /img/user_manual/image94.png
    :align: center

    `Image 118 - Selected record (blue), hovered records (yellow) - Contributions Panel`

  In the second **Payer** column of Contributions data grid, there is a link showing (institutional) payer of the contribution on the corresponding row. When the link is clicked; a popup browser window (:ref:`imgae119`) will open up showing the details of the payer in read-only mode.

  .. _image119:
  .. figure:: /img/user_manual/image95.png
    :align: center

    `Image 119 - Payer Pop up – Contribution Panel`

  In the ``Contributions Panel``, action buttons allow to add, edit and delete contributions.

  .. _image120:
  .. figure:: /img/user_manual/image96.png
    :align: center

..

    The ``green plus sign`` is for adding a new contribution.

    The ``yellow pencil sign`` is for editing a contribution.

    The ``red cross sign`` is for deleting a contribution.

  E. Button Panel

  The ``Cancel`` button re-directs to the `Home Page <#image-2.2-home-page>`__.

  F. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once an insuree, a policy or a contribution have been added, updated or deleted or if there was an error at any time during the process of these actions.

Family/Group Page
"""""""""""""""""

.. _image121:
.. figure:: /img/user_manual/image97.png
  :align: center

  `Image 121 - Family/Group Page`

..

    -  ``Region``

      Select from the list of available regions the region, in which the head of family/group permanently stays. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.* Mandatory.

    -  ``District``

      Select from the list of available districts the district, in which the head of family/group permanently stays. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected*. Mandatory.

    -  ``Municipality``

      Select from the list of available municipalities the municipality, in which the head of family/group permanently stays. *Note: The list will only be filled with the municipalities belonging to the selected district.* Mandatory.

    -  ``Village``

      Select from the list of available villages the village, in which the head of family/group permanently stays. *Note: The list will only be filled with the villages belonging to the selected municipality.* Mandatory.

    -  ``Poverty Status``

      Select whether the family/group has the poverty status. Mandatory.

    -  ``Confirmation Type``

      Select the type of a confirmation of the social status of the family/group.

    -  ``Confirmation No.``

      Enter alphanumeric identification of the confirmation of the social status of the family/group.

    -  ``Group Type``

      Select the type of the group/family.

    -  ``Address Details.``

      Enter details of the permanent address of the family/group.

    -  ``Insurance Number``

      Enter the insurance number for the head of family/group. Mandatory.

    -  ``Last name``

      Enter the last name (surname) for the head of family/group. Mandatory.

    -  ``Other Names``

      Enter other names of the head of family/group. Mandatory.

    -  ``Birth Date``

        Enter the date of birth for the head of family/group. *Note: You can also use the button next to the birth date field to select a date to be entered.*

    -  ``Gender``

      Select from the list of available genders the gender of the head of family/group. Mandatory.

    -  ``Marital Status``

      Select from the list of available marital statuses the marital status of the head of family/group. Mandatory.

    -  ``Beneficiary Card``

      Select from the list of card whether or not an insurance identification card was issued to the head of family/group. Mandatory.

    -  ``Current Region``

      Select from the list of available regions the region, in which the head of family/group temporarily stays.

    -  ``Current District``

      Select from the list of available districts the district, in which the head of family/group temporarily stays. *Note: The list will only be filled with the districts belonging to the selected region*

    -  ``Current Municipality``

      Select from the list of available municipalities the municipality, in which the head of family/group temporarily stays. *Note: The list will only be filled with the municipalities belonging to the selected district.*

    -  ``Current Village``

      Select from the list of available villages the village, in which the head of family/group temporarily stays. *Note: The list will only be filled with the villages belonging to the selected municipality.*

    -  ``Current Address Details``

      Enter details of the temporal address of the head of family/group.

    -  ``Profession``

      Select the profession of the head of family/group.

    -  ``Education``

      Select the education of the head of family/group.

    -  ``Phone Number``

      Enter the phone number for the head of family/group.

    -  ``Email``

      Enter the e-mail address of the head of family/group.

    -  ``Identification Type``

      Select the type of the identification document of the head of family/group.

    -  ``Identification No.``

      Enter alphanumeric identification of the document of head of family/group.

    -  ``Region of FSP``

      Select from the list of available regions the region, in which the chosen primary health facility (First Service Point) of the head of family/group is located.

    -  ``District of FSP``

      Select from the list of available districts the district, in which the chosen primary health facility (First Service Point) of the head of family/group is located. *Note: The list will only be filled with the districts belonging to the selected region.*

    -  ``Level of FSP``

      Select the level of the chosen primary health facility (First Service Point) of the head of family/group.

    -  ``First Service Point``

      Select from the list of available health facilities the chosen primary health facility (First Service Point) of the head of family/group. *Note: The list will only be filled with the health facilities belonging to the selected district which are of the selected level.*

    -  ``Browse``

      Browse to get the photo for the head of family/group related to his/her insurance number.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Family Overview Page <#family-overview-page.>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the family member has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Find Family Page <#find-family-page>`__.

Adding a Family
"""""""""""""""

Click on the ``Green Plus Sign`` to re-direct to the `Family/Group Page <#familygroup-page>`__\ .

..

When the page opens all entry fields are empty. See the `Family/Group Page <#familygroup-page>`__ for information on the data entry and mandatory fields.

Editing a Family/Group
""""""""""""""""""""""

Click on the Yellow Pencil Sign to re-direct to the `Change Family/Group Page <#section-9>`__

..

The page will open with the current information loaded into the data entry fields, plus there are options to change the head of the family/group and move an insuree to the family/group.

.. _image122:
.. figure:: /img/user_manual/image98.png
  :align: center

  `Image 122 - Change Family/Group Page`

Changing a Head of Family/Group
"""""""""""""""""""""""""""""""

The head of the Family/Group is the main contact associated with a^policy. For various reasons it may be necessary to change the head of a family/group. The new head must a head of family in another family.

..

Enter the insurance number for the new head of family/group, click on check, to confirm that the insurance number is valid and that it really is the person expected. The name will appear to the right of the check button. If all is OK, click on the Change button to complete the change. On a successful change, the user will be re-directed back to the `Family Overview Page <#family-overview-page.>`__\ ; the new head will be displayed in the Family/Group Information Panel

Moving an Insuree
"""""""""""""""""

Insurees may be moved from one family/group to another. The new insuree must not be a head of family/group in another family/group.

..

Enter the insurance number for the insuree to move. Click on check, to confirm that the insurance number is valid and that it really is the person expected. The name will appear to the right of the check button. If all is OK, click on the Change button to complete the change. On a successful change, the user will be re-directed back to the `Family Overview Page <#family-overview-page.>`__ the new insuree will be displayed in the insuree Information Panel.

Deleting a Family/Group
"""""""""""""""""""""""

Click on the Red Cross Sign button to delete the currently selected record\ .

..

Before deleting a confirmation popup (:ref:`image123`) is displayed, which requires the user to confirm if the action should really be carried out? Deleting of a family requires deleting of all its dependants first.

.. _image123:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 123 - Delete confirmation- Button Panel`

When a family is deleted, all records retaining to the deleted family will still be available by selecting historical records.

Insuree Page
""""""""""""

  **1. Data Entry**

  .. _image124:
  .. figure:: /img/user_manual/image100.png
    :align: center

    `Image 124 - Insuree Page`

..

    -  ``Relationship``


      Select from the list of available relationships of the insuree to the head of family/group.

    -  ``Insurance Number``

      Enter the insurance number for the insuree. Mandatory.

    -  ``Last name``

      Enter the last name (surname) for the insuree. Mandatory, 100 characters maximum.

    -  ``Other Names``

      Enter other names of the insuree. Mandatory, 100 characters maximum.

    -  ``Birth Date``

      Enter the date of birth for the insuree. *Note: You can also use the button next to the birth date field to select a date to be entered.*

    -  ``Gender``

      Select from the list of available genders the gender of the insuree. Mandatory.

    -  ``Marital Status``

      Select from the list of available options for the marital status of the insuree. Mandatory.

    -  ``Beneficiary Card``

      Select from the list of options whether or not the card was issued to the insure. Mandatory.

    -  ``Current Region``

      Select from the list of available regions the region, in which the insuree temporarily stays.

    -  ``Current District``

      Select from the list of available districts the district, in which the insuree temporarily stays. *Note: The list will only be filled with the districts belonging to the selected region*

    -  ``Current Municipality``

      Select from the list of available municipalities the municipality, in which the insuree temporarily stays. *Note: The list will only be filled with the municipalities belonging to the selected district.*

    -  ``Current Village``

      Select from the list of available villages the village, in which the insuree temporarily stays. *Note: The list will only be filled with the villages belonging to the selected municipality.*

    -  ``Current Address Details.``

      Enter details of the temporal address of the insuree.

    -  ``Profession``

      Select from the list of available professions the profession of the insuree.

    -  ``Education``

      Select from the list of available educations the education of the insuree.

    -  ``Phone Number ``

      Enter the phone number for the insuree.

    -  ``Email``

      Enter the e-mail address of the insuree.

    -  ``Identification Type``

      Select the type of the identification document of the insuree.

    -  ``Identification No.``

      Enter alphanumeric identification of the document of the insuree.

    -  ``Region of FSP``

      Select from the list of available regions the region, in which the chosen primary health facility (First Service Point) of the insuree is located.

    -  ``District of FSP``

      Select from the list of available districts the district, in which the chosen primary health facility (First Service Point) of the insuree is located. *Note: The list will only be filled with the districts belonging to the selected region.*

    -  ``Level of FSP``

      Select the level of the chosen primary health facility (First Service Point) of the insuree.

    -  ``First Service Point``

      Select from the list of available health facilities the chosen primary health facility (First Service Point) of the insuree. *Note: The list will only be filled with the health facilities belonging to the selected district which are of the selected level.*

    -  ``Browse``

      Browse to get the photo for the insuree related to his/her insurance number.

  *Note: There is an automated service in the IMIS Server which will run on configured time basis repeatedly and assign related photos to insurees without photos if any exist in the IMIS database. So after a user has input insuree's insurance number and no photo is displayed, there is no need to browse for the photo as that process will be done automatically by the service if the service is configured.*

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Family Overview Page <#family-overview-page.>`__, with the newly saved record displayed and selected in the result panel. A message confirming that the insuree has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk)

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Family Overview Page <#family-overview-page.>`__.

Adding an Insuree
"""""""""""""""""

Click on the Green Plus Sign to re-direct to the `Insuree Page <\l>`__\ .

..

When the page opens all entry fields are empty. See the `Insuree Page <#insuree-page>`__ for information on the data entry and mandatory fields.

Editing an Insuree
""""""""""""""""""

Click on the Yellow Pencil Sign to re-direct to the `Insuree Page <#insuree-page>`__\ .

The page will open with the current information loaded into the data entry fields. See the Insuree Page for information on the data entry and mandatory fields.

Deleting an Insuree
"""""""""""""""""""

Click on the Red Cross Sign to delete the currently selected record.

..

Before deleting a confirmation popup (:ref:`image125`) is displayed, which requires the user to confirm if the action should really becarried out?

.. _image125:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 125 - Delete confirmation- Button Panel`

When an insuree is deleted, all records retaining to the deleted insuree will still be available by selecting historical records.

Policy Page
"""""""""""

  **1. Data Entry**

  .. _image126:
  .. figure:: /img/user_manual/image102.png
    :align: center

    `Image 126 - Policy Page`

..

    -  ``Enrolment Date``

      Enter the enrolment date for the policy. Mandatory. *Note: You can also use the button next to the enrolment date field to select a date to be entered.*

    -  ``Product``

      Select from the list of available products the product of the policy. Mandatory.

    -  ``Effective Date``

      The effective date for the policy is calculated automatically later on. The effective date is the maximum of the start date and the date when the last contribution was paid or when the user enforced activation of the policy.

    -  ``Start Date``

      The start date for the policy is calculated automatically. Either it is the enrolment date plus the administration period of the insurance product associated with the policy for free enrolment (without cycles) or it is a cycle start date determined according to enrolment date and the administration period for enrolment in fixed cycles. The start date may be modified by the user.

    -  ``Expiry Date``

      The expiry date for the policy is calculated automatically. When entering a new policy, the expiry date is the start date plus the insurance period of the insurance product associated with the policy for free enrolment or the cycle start date plus the insurance period for enrolment in fixed cycles.

    -  ``Enrolment Officer``

      Select from the list of available enrolment officers the enrolment officer related to the policy. Mandatory

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Family Overview Page, <#family-overview-page.>`__ with the newly saved record displayed and selected in the result panel. A message confirming that the policy has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk).

  **4. Cancel**

  By clicking on the ``Cancel`` \ button, the user will be re-directed to the `Family Overview Page <#family-overview-page.>`__.

Adding a Policy
"""""""""""""""

Click on the ``Green Plus Sign`` to re-direct to the `Policy Page <#policy-page>`__\ .

..

When the page opens all entry fields are empty. See the `Policy Page <#policy-page>`__ for information on the data entry and mandatory fields.

Editing a Policy
""""""""""""""""

Click on the ``Yellow Pencil Sign`` to re-direct to the `Policy^Page <#policy-page>`__\ .

..

The page will open with the current information loaded into the data entry fields. See the `Policy Page <#policy-page>`__ for information on the data entry and mandatory fields.

Deleting a Policy
"""""""""""""""""

Click on the ``Red Cross Sign`` to delete the currently selected policy.

..

Before deleting of a policy, all contributions of the policy should be deleted. Before deleting a confirmation popup (:ref:`image127`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image127:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 127 - Delete confirmation- Button Panel`

When a policy is deleted, all records retaining to the deleted policy will still be available by selecting historical records.

Contribution Page
"""""""""""""""""

  **1. Data Entry**

  .. _image128:
  .. figure:: /img/user_manual/image104.png
    :align: center

    `Image 128 - Contribution Page`

..

    -  ``Payer``

      Select from the list of available (institutional) payers the payer of the contribution (if the contribution is not paid by the family/group itself).

    -  ``Contribution Paid``

      Enter the paid amount for the contribution. Mandatory.

    -  ``Receipt No.``

      Enter the receipt identification for the contribution. Receipt identification has to be unique within all policies of the insurance product. Mandatory.

    -  ``Payment Date``

      Enter the date of payment for the contribution. Mandatory. *Note: You can also use the button next to the date of payment field to select a date to be entered.*

    -  ``Payment Type``

      Select from the list of available types of payment the payment type of the contribution. Mandatory.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. Depending on the contribution paid, the following messages will appear.

    a) If the Contribution paid matches the price of the policy:

    .. _image129:
    .. figure:: /img/user_manual/image105.png
      :align: center

    b) If the contribution paid is lower than the price of the policy:

    .. _image130:
    .. figure:: /img/user_manual/image106.png
      :align: center

    Followed by:

    .. _image131:
    .. figure:: /img/user_manual/image107.png
      :align: center

    If you choose **Yes**, the policy will be (enforced) set as **Active**. If you choose No, it will remain **Idle**.

    c) If the contribution is higher than the price of the policy:

    .. _image133:
    .. figure:: /img/user_manual/image108.png
      :align: center

    The user will then be re-directed back to the `Family Overview Page <#family-overview-page.>`__\ , with the newly saved record displayed and selected in the result panel. A message confirming that the contribution has been saved will appear on the Information Panel.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk).

  **4. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Family Overview Page <\l>`__ .

Adding a Contribution
"""""""""""""""""""""

Click on the ``Green Plus Sign`` to re-direct to the `Contribution Page. <#contribution-page>`__

..

When the page opens all entry fields are empty. See the `Contribution Page <#contribution-page>`__ for information on the data entry and mandatory fields.

Editing a Contribution
""""""""""""""""""""""

Click on the ``Yellow Pencil`` Sign to re-direct to the `Contribution Page <#contribution-page>`__. The `Contribution Page <#contribution-page>`__ will open with the current information loaded into the data entry fields. See the `Contribution Page <#contribution-page>`__ for information on the data entry and mandatory fields.

Deleting a Contribution
"""""""""""""""""""""""

Click on the Red Cross Sign button to delete the currently selected record.

..

Before deleting a confirmation popup (:ref:`image134`) is displayed, which requires the user to confirm if the action should really be carried out?

.. _image134:
.. figure:: /img/user_manual/image24.png
  :align: center

  `Image 134 - Delete confirmation- Button Panel`

When a contribution is deleted, all records retaining to the deleted contribution will still be available by selecting historical records.

Claims
------

The functionality under the menu ``Claims`` allows complete processing of claims from their entering into IMIS, modification, submission to processing, automatic checking of their correctness, reviewing of them by medical officers, their evaluating and preparation of report to an accounting system for their remuneration to contractual health facilities. Each claim can be consequently in several states. Once it is entered to IMIS (either by the mobile phone application **Claim Management** or typed in and saved in IMIS) it goes to the status **Entered**. When it is submitted and it successfully passes at least some automatic checks, the claim goes to the status **Checked**. If the claim doesn’t pass automatic checking it goes to the status **Rejected** and its processing ends. The claim in the status **Checked** may be reviewed from medical point of view and/or a feedback on it can be collected from the patient. Medical reviewing and feedback acquiring can be by-passed. Ones such (manual) scrutiny of the claim is at the end, the claim may be pushed to the status **Processed**. In this status the claim is evaluated in nominal prices, taking into account all ceilings, deductibles and other cost sharing rules associated with insurance product or products covering claimed health care. If there is no medical service or medical item price of which a relative one according to the corresponding insurance product, the claim goes automatically to the status **Valuated**. If there is at least one medical service or medical item with relative pricing, the claim goes to the status **Valuated** only after a batch for corresponding period is run. The batch for a period (month, quarter, year) finishes evaluation of relative prices on claims on one hand and summarizes all claims in the period for accounting system that is external to IMIS (it is not a part of it). Different values (prices) of a claim are associated with each stage of processing of claims. When a claim is entered the value of the claim based on nominal prices of claimed medical services/items is designated as **Claimed Value**. **Claimed Value** is associated with the state **Entered**. The value of the claim after automatic checking of claims during submission of the claim and after manual interventions of medical officers is designated as **Approved Value**. **Approved Value** is associated with the state **Checked**. The value of the claim after corrections based on all cost sharing rules of covering insurance products is designated as **Adjusted Value**. **Adjusted Value** is associated with the state **Processed**. The final value of the claim taking into account actual value of relative prices is designated as **Paid Value**. **Paid Value** is associated with the state **Valuated**.

Heath Facility Claims
^^^^^^^^^^^^^^^^^^^^^

Access to the ``Health Facility Claims Page`` is restricted to users with the role of Claim Administrator.

Pre-conditions
""""""""""""""

Navigation
""""""""""

All functionality for use with the administration of health facility claims can be found under the main menu ``Claims``, sub menu ``Health Facility Claims``.

.. _image135:
.. figure:: /img/user_manual/image110.png
  :align: center

  `Image 135 - Navigation Health Facility Claims`

Clicking on the sub menu ``Health Facility Claims`` re-directs the current user to the `Claims Control Page <#_Health_Facility_Claims>`__\ .

Claims Control Page
"""""""""""""""""""

.. _image136:
.. figure:: /img/user_manual/image111.png
  :align: center

  `Image 136 - Claims Control Page`

The Claims Control Page is the central point for all health facility claim administration. By having access to this panel, it is possible to add, edit and search claims. Claims can be edited only in the state **Entered**. The panel is divided into four panels (:ref:`image136`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of claims the following search options are available which can be used alone or in combination with each other.

    -  ``Region``

      Select the ``Region``; where claiming or searched for health facility is located from the list of regions by clicking on the arrow on the right of the selector to select claims from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected*

    -  ``District``

      Select the ``district``; where claiming or searched for health facility is located from the list of districts by clicking on the arrow on the right of the selector to select claims from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``HF Code``

      Select the ``HF Code`` (Health Facility Code) from the list of codes of health facilities by clicking on the arrow on the right of the selector, to select claims from a specific health facility. *Note: The list will only be filled with the health facilities belonging to the selected district and assigned to the current logged in user.*

    -  ``HF Name``

      Type in the beginning of; or the full ``HF Name`` (Health Facility Name) to search for claims belonging to the health facility whose name start with or match completely the typed text.

    -  ``Claim Administrator``

      Select the ``Claim Administrator`` from the list of claim administrators by clicking on the arrow on the right of the selector, to select claims submitted by a specific claim administrator. *Note: The list will only be filled with the claim administrators belonging to the health facility selected.*

    -  ``Visit Type``

      Select the ``Visit Type`` from the list of visit types (or hospital stays) by clicking on the arrow on the right of the selector, to select claims with specified visit type.

    -  ``Insurance Number``

      Type in the beginning of; or the full ``Insurance Number``, to search for claims, on behalf of insurees with the insurance number which starts with or match completely the typed text.

    -  ``Claim No.``

      Type in the beginning of; or the full ``Claim No.``, to search for claims with the specific claim identification which starts with or match completely the typed text.

    -  ``Review Status``

      Select the ``Review Status`` from the list of options for review status by clicking on the arrow on the right of the selector, to select claims with specific review status.

    -  ``Feedback Status``

      Select the ``Feedback Status`` from the list of options for feedback status by clicking on the arrow on the right of the selector, to select claims with specific feedback status.

    -  ``Claim Status``

      Select the ``Claim Status`` from the list of options for claim status by clicking on the arrow on the right of the selector, to select claims with specific claim status.

    -  ``Main Dg.``

      Select the ``Main Dg.`` from the list of diagnoses status by clicking on the arrow on the right of the selector, to select claims with main diagnosis.

    -  ``Batch Run``

      Select the ``batch run`` from the list of batch runs by clicking on the arrow on the right of the selector, to select claims from specific batch run

    -  ``Visit Date From``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Visit Date From`` date which is on or is greater than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.* ``Visit Date From`` should be the day of admission for in-patient care or the visit date in case of out-patient care.

    -  ``Visit Date To``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Visit Date From`` date which is on or is less than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.* ``Visit Date To`` should be the day of discharge for in-patient care or the visit date in case of out-patient care.

    -  ``Claim Date From``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Claim Date`` date which is on or is greater than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Claim Date To``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Claim Date`` date which is on or is less than the date typed/selected. Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image137`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of today.
        -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image137:
      .. |logo33| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo34| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo35| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo33| || |logo34| || |logo35| |
      +----------++----------++----------+

        `Image 137 - Calendar Selector - Search Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Result Panel

  The Result Panel displays a list of all claims found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image138`). The leftmost record contains a hyperlink which if clicked, re-directs the user to the actual record for detailed viewing if it is a historical record or editing if it is the current record.

  .. _image138:
  .. figure:: /img/user_manual/image112.png
    :align: center

    `Image 138 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 2000 records can be displayed at one time, in a scroll panel. Further records can be viewed by processing the current loaded claims and search claims again.

  C. Button Panel

  With exception of the ``Cancel`` button, which re-directs to the `Home Page <#image-2.2-home-page>`__, and the ``Add`` button which re-directs to the `Claim Page, <#claim-page>`__ the button panel (the buttons Load and Submit) is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record except the leftmost hyperlink, and then click on the button.

    -  ``add``

      By clicking on the add button, the user is directed to the `Claim Page, <#claim-page>`__ where new entries for new claim can be added. When the page opens all entry fields are empty. See the `Claim Page <#claim-page>`__ for information on the data entry and mandatory fields.

    -  ``load``

      By clicking on the load button, the user is directed to the `Claim Page <#claim-page>`__, where the current selected claim can be edited (provided it in the state **Entered**).

      ..

      The page will open with the current information loaded into the data entry fields. See the `Claim Page <#claim-page>`__ for information on the data entry and mandatory fields.

    -  ``submit``

      By clicking on the submit button, claim status of all claims with claim status **Entered** and which have been selected to be submitted by checking the check box on right end of each record, will be submitted.

      ..

      On the top of result panel, there is a checkbox to be used to select all claims currently loaded in the result panel and whose claim status is **Entered**, prior to be submitted.

      ..

      Once the process is done, a popup window (:ref:`image140`) with the result of the process will be shown.

      .. _image139:
      .. figure:: /img/user_manual/image113.png
        :align: center

        `Image 139 - Submit Claims Prompt – Claims Control Page`


      .. _image140:
      .. figure:: /img/user_manual/image114.png
      :align: center

      `Image 140 - Submitted Claims details – Claims Control Page`

    -  ``delete``

      By clicking on the delete button, the current selected claim will be deleted.

      ..

      Before deleting a confirmation popup (:ref:`image141`) is displayed, which requires the user to confirm if the action should really be carried out?

      .. _image141:
      .. figure:: /img/user_manual/image24.png
        :align: center

        `Image 141 - Delete confirmation – Claims Control Page`

    -  ``cancel``

      By clicking on the ``Cancel`` button, the user will be re-directed to the `Home Page <#image-2.2-home-page>`__.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a claim has been added, updated or deleted or if there was an error at any time during the process of these actions.

Claim Page
""""""""""

  **1.  Data Entry**

  .. _image142:
  .. figure:: /img/user_manual/image116.png
    :align: center

    `Image 142 - Claim Page`

  ..

    -  ``HF Code``

      Displays the code of the health facility. The field is read only (taken over from the `Claims Control Page) <#_Health_Facility_Claims>`__ and cannot be edited.

    -  ``HF Name``

      Displays the name of the health facility. The field is read only (taken over from the `Claims Control Page <#_Health_Facility_Claims>`__) and cannot be edited.

    -  ``Insurance Number``

      Enter the insurance number of the patient. When done entering this field, the corresponding name of the patient will be filled on the name of the patient (the text box which is read only field and is on the right side of the Insurance Number text field). Mandatory.

    -  ``Claim No.``

      Enter the identification of the claim. Mandatory, up to 8 characters. It should be unique within the claiming health facility.

    -  ``Main Dg.``

      Select the code of the main diagnosis from the drop down list of diagnosis codes. Mandatory.

    -  ``Sec Dg 1``

      Select the code of the first secondary diagnosis from the drop down list of diagnosis codes.

    -  ``Sec Dg 2``

      Select the code of the second secondary diagnosis from the drop down  list of diagnosis codes.

    -  ``Sec Dg 3``

      Select the code of the third secondary diagnosis from the drop down list of diagnosis codes.

    -  ``Sec Dg 4``

      Select the code of the fourth secondary diagnosis from the drop down list of diagnosis codes.

    -  ``Claim Administrator``

      Displays code of the claim administrator. The field is read only (taken over from `the Claim Control Page <#_Health_Facility_Claims>`__) and cannot be edited.

    -  ``Visit Date From``

      Enter the visit date for out-patient care or the admission date for in-patient care. Mandatory.

    -  ``Visit Date To``

      Enter the discharge date for in-patient care.

    -  ``Date Claimed``

      Enter the date when the claim was prepared by the health facility.

    -  ``Guarantee No.``

      Enter identification of a guarantee letter for prior approval of provision of claimed health care.

    -  ``Visit Type``

      Select the type of visit/hospital admission from the drop down list (**Emergency, Referral, Other**)

    -  ``Services``

      1. ``service code``

        When entering the service code, a dropdown suggestion box for the available services with the service code or service name matching your typed text will be shown. Available medical services in the dropdown suggestion box are taken over from the pricelist of medical services associated with the claiming health facility. The desired service can then be selected from the dropdown suggestion box by clicking on it using mouse or selecting it using up and down arrows, then pressing Enter key fill the service code text field, together with quantity and value field in the same row.

        ..

        Once the selected service has been written on the service data grid row, the dropdown suggestion box will close itself. When needed, the dropdown suggestion box can be closed by clicking any place on the page but outside the dropdown suggestion box.

        .. _image143:
        .. figure:: /img/user_manual/image117.png
          :align: center

          `Image 143 - Services dropdown suggestion box – Claim Page`

      2. ``quantity``

        This field can be filled manually by entering a number in it or automatically is filled by 1 when the service code above is filled, through dropdown suggestion box. It is this field that receives focus after service code is filled above from the dropdown suggestion box.

      3. ``price``

        This field can be filled manually by entering a number in it or automatically is filled when the service code above is filled, through dropdown suggestion box. Automatically filled prices are taken over from the pricelist of medical services associated with the claiming health facility.

      4. ``explanation``

        Enter extra information about the service for the scheme administration (a medical officer of the scheme administrator).

    -  ``Items``

      1. ``item code``

        When entering the item code, a dropdown suggestion box for the available items with the item code or item name matching your typed text will be shown. Available medical items in the dropdown suggestion box are taken over from the pricelist of medical items associated with the claiming health facility. The desired item can then be selected from the dropdown suggestion box by clicking on it using mouse or selecting it using up and down arrows, then pressing Enter key to fill the item code text field, together with quantity and value field in the same row.

        ..

        Once the selected item has been written on the item data grid row, the dropdown suggestion box will close itself. When needed, the dropdown suggestion box can be closed by clicking any place on the page but outside the dropdown suggestion box.

        .. _image144:
        .. figure:: /img/user_manual/image118.png
          :align: center

          `Image 144 - Items dropdown suggestion box – Claim Page`

      2. ``quantity``

        This field can be filled manually by entering a number in it or automatically is filled by 1 when the item code above is filled, through dropdown suggestion box. It is this filled that receives focus after item code is filled above from the dropdown suggestion box.

      3. ``price``

        This field can be filled manually by entering a number in it or automatically is filled when the item code above is filled, through dropdown suggestion box. Automatically filled prices are taken over from the pricelist of medical items associated with the claiming health facility.

      4. ``explanation``

        Enter extra information about the medical item for the scheme administration (a medical officer of the scheme administrator).

    -   ``claimed``

      This field is filled automatically with a new total of quantities multiplied to their corresponding values in both data input grids at any time when there is a change in values in the either quantity fields or value fields anywhere in both data input grids.

    -  ``explanation``

      Enter extra information about the whole claim for the scheme administration (medical officer).

  **#  User Controls**

  On top of services input grid panel and items input grid panel, there is a textbox field (:ref:`image145`) and (:ref:`image146`) which is filled with a constant representing the current number of rows in the input grid a user is working with. A user can change the current number of rows in the corresponding data input grid by entered a number of rows greater than existing one. This change is only allowed before a user has made changes to the corresponding data input grid.

  .. _image145:
  .. figure:: /img/user_manual/image119.png
    :align: center

    `Image 145 - Services input grid row number change, input field – Claim Page`

  .. _image146:
  .. figure:: /img/user_manual/image120.png
    :align: center

    `Image 146 - Items input grid row number change, input field – Claim Page`

  A user can manually clear the inputs in the row by clicking the ``Red Cross`` button on the end right of a desired row (:ref:`image147`). This action will require a user to confirm for the clearing process to proceed by choosing either yes / no from the popup window (:ref:`image148`) asking for user confirmation.

  .. _image147:
  .. figure:: /img/user_manual/image121.png
    :align: center

    `Image 147 - Clear row inputs button-Claim Page`

  .. _image148:
  .. figure:: /img/user_manual/image122.png
    :align: center

    `Image 148 - Clearing of a row confirmation – Claim Page`

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the claim. The user stay in the `Claim Page <#claim-page>`__; a message confirming that the claim has been saved will appear on the bottom of the `Claim Page <#claim-page>`__.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk).

  **4. Printing of a claim**

  By clicking on the ``Print`` button, the user will be shown a printable version of the claim details page. The printable version of the claim is available in the following formats (Word, PDF, Excel)

  **5. Creating of a new claim**

  By clicking on the ``Add`` button, the `Claim Page <#claim-page>`__ is cleared (with exception of HF Code, HF Name and Claim Administrator) and it ready for entering of a new claim for the same health facility and of the same claim administrator as before.

  **6. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Claims Control Page <#_Health_Facility_Claims>`__\ .

Review claims
^^^^^^^^^^^^^

The functionality allows reviewing and adjustments of claims from medical point of view. Reviewing of claims is restricted to users with the role of Medical Officer

Pre-conditions
""""""""""""""

A claim has been already submitted.


Navigation
""""""""""

All functionality for use with the administration of claim overview can be found under the main menu ``Claims``, sub menu ``Review.``

.. _image149:
.. figure:: /img/user_manual/image123.png
  :align: center

  `Image 149 - Navigation Review`

Clicking on the sub menu ``Review`` re-directs the current user to the `Claims Overview Page. <#claims-overview-page>`__

.. _image150:
.. figure:: /img/user_manual/image124.png
  :align: center

  `Image 150 - Claims Overview Page`

Claims Overview Page
""""""""""""""""""""

The Claims Overview Page is the central point for all claim review administration. By having access to this panel, it is possible to review, feedback, amend and process claims. The panel is divided into five sections (:ref:`image150`).

  A. Search Panel

  The search panel allows a user to select specific criteria to minimise the search results. In the case of claims the following search options are available, which can be used alone, or in combination with each other.

    -  ``Region``

      Select the ``Region``; where searched for health facility is located or where patients are permanently living from the list of regions by clicking on the arrow on the right of the selector to select claims from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected*

    -  ``District``

      Select the ``District``; where searched for health facility is located or where patients are permanently living from the list of districts by clicking on the arrow on the right of the selector to select claims from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``HF Code``

      Select the ``HF Code``; from the list of health facilities codes by clicking on the arrow on the right of the selector to select claims from a specific health facility. *Note: The list will only be filled with the health facilities belonging to the selected district and assigned to the current logged in user.*

    -  ``HF Name``

      Type in the beginning of; or the full ``HF Name``, to search for claims belonging to the health facility whose name start with or match completely the typed text.

    -  ``Claim Administrator``

      Select the ``claim administrator`` from the list of claim administrator codes by clicking on the arrow on the right of the selector, to select claims submitted by a specific claim administrator. *Note: The list will only be filled with the claim administrators belonging to the health facility selected.*

    -  ``Insurence Number``

      Type in the beginning of; or the full ``Insurence Number``, to search for claims for patients with the insurance number which start with or match completely the typed text.

    -  ``Claim No.``

      Type in the beginning of; or the full ``Claim No.``, to search for claims with claim identification which start with or match completely the typed text.

    -  ``Review Status``

      Select the ``Review Status`` from the list of the options for review status by clicking on the arrow on the right of the selector, to select claims with a specific review status.

    -  ``Feedback Status``

      Select the ``Feedback Status`` from the list of the options for feedback status by clicking on the arrow on the right of the selector, to select claims with a specific feedback status.

    -  ``Claim Status``

      Select the ``Claim Status`` from the list of options for claim status by clicking on the arrow on the right of the selector, to select claims with a specific claim status.

    -  ``Main Dg``

      Select the ``Main Dg.`` from the list of diagnoses status by clicking on the arrow on the right of the selector, to select claims with main diagnosis.

    -  ``Batch Run``

      Select the ``Batch Run`` from the list of batch runs by clicking on the arrow on the right of the selector, to select claims included in a specific batch run.

    -  ``Visit Date From``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Visit Date From`` which is on or is greater than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Visit Date To``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Visit Date To`` which is on or is less than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Claim Date From``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Claim Date From`` which is on or is greater than the  date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Claim Date To``

      Type in a date; or use the Date Selector Button, to search for claims with a ``Claim Date To`` which is on or is less than the date typed/selected. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Visit Type``

      Select type of out-patient visit or in-patient admission from the list of types of visit to search for claims made on specific visit/admission type.

    -  ``Date Selector Button``

      Clicking on the Date Selector Button will pop-up an easy to use, calendar selector (:ref:`iamge151`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of today.
        -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image151:
      .. |logo36| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo37| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo38| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo36| || |logo37| || |logo38| |
      +----------++----------++----------+

        `Image 151 - Calendar Selector - Search Panel`

    -  ``Search Button``

      Once the criteria have been entered, use the search button to filter the records, the results will appear in the Result Panel.

  B. Claim Selection Update Panel

  This panel is basically for functionality of updating multiple claims which are currently loaded in the Result Panel at once basing on the claim filter criteria available on this panel. The update on the claims is basically changing **Feedback Status** and **Review Status** of a claim from **Idle** to (**Not**) **Selected for Feedback** or (**Not**) **Selected for Review** respectively. The filters in this panel work on the claims which are currently loaded on the result panel. The combination of filters is either ``Select`` alone or ``Select`` and either ``Random`` or ``Value`` or ``Variance`` or combination of ``Value`` and ``Variance``.

    -  ``select``

      Is a selection dropdown box to select between **Review Select** and **Feedback Select** to filter only claims whose review status is **Idle** or feedback status is **Idle** respectively from among claims currently in the Result Panel.

    -  ``Random``

      Accept a number which is considered to be a percentage of the claims in the Result Panel. Check the random checkbox and enter a number on the text field next to checkbox. The default is 5%.

    -  ``Value``

      Accept a number which is considered to be claimed value. This will filter claims from the Result Panel by taking claims whose claimed value is equal or greater than the entered number in the Value text field. Check the value checkbox and enter a number on the text field next to checkbox. The default is 40000.

    -  ``variance``

      Accept a number which is considered to be a percentage of the current claim value variance. Calculated by dividing the current claim value **(value)** and the average sum **(Average)** of the all claims in the previous year from the current claim date and with the same main diagnosis as that of the current claim, minus one **(1)** and finally multiply by hundred **(100)** to get the percentage variance. I.e **Percentage Variance = [(Value / Average) – 1] \* 100** Enter a number by checking the variance checkbox and enter a number on the text field next to checkbox. The default is 50%.

    -  ``Update button``

      Once desired criteria have been set and after clicking this button, then the claims currently displayed in the result panel which satisfy the criteria, will be updated of their **Idle** Review Status or Feedback Status to either (**Not**) **Selected for Review** or (**Not**) **Selected for Feedback** respectively.

      ..

      A popup prompt window will be displayed to confirm the process, as shown on (:ref:`image152`) and (:ref:`image153`).

      ..

      Once the update process is over, a popup window (:ref:`image154`). Showing the result of the process will be displayed.

      .. _image152:
      .. figure:: /img/user_manual/image125.png
        :align: center

        `Image 152 - Claim Feedback Selection Update Prompt – Claims Overview Page`

      .. _image153:
      .. figure:: /img/user_manual/image126.png
        :align: center

        `Image 153 - Claim Review Selection Update Prompt – Claims Overview Page`

      .. _image154:
      .. figure:: /img/user_manual/image127.png
        :align: center

        `Image 154 - Claim Selection Update Results – Claims Overview Page`

  C. Result Panel

  The Result Panel displays a list of all claims found, matching the selected criteria in the search panel. The currently selected record is highlighted with light blue, while hovering over records changes the highlight to yellow (:ref:`image155`).

  .. _image155:
  .. figure:: /img/user_manual/image128.png
    :align: center

    `Image 155 - Selected record (blue), hovered records (yellow) - Result Panel`

  A maximum of 2000 records can be displayed at one time, in a scroll panel. Further records can be viewed by processing the current loaded claims and search claims again.

  ..

  The Feedback and Review Status Columns in each row contain a drop down list with options for claim feedback status and claim review status. A user can change the claim feedback and review status from low status to high status only. Either from **Idle** to **Not Selected** or **Selected for Feedback** in case of the feedback status or **Not Selected** or **Selected for Review** in case of the review status. Or from **Not Selected** to **Selected for Feedback** in case of the feedback status or **Selected for Review** in case of the review status. For changes to take effect, a user will have to update the changes by clicking the ``Update`` button.

  D. Button Panel

  With exception of the Cancel button, which re-directs to the `Claims Overview Page <#claims-overview-page>`__, the button panel is used in conjunction with the current selected record (highlighted with blue). The user should first select a record by clicking on any position of the record.

    -  ``review``

      Clicking on this button re-directs a user to the `Claim Review Page <#claim-review-page>`__, where a claim with review status **Selected for Review** can be reviewed and its current review status changed to **Reviewed.** If the claim is not in the status **Selected for Review** then the claim can be only loaded and shown to the user without any subsequent action.

      ..

      The page will open with the current information loaded into the data entry fields. See the `Claim Review Page <#claim-review-page>`__, for information on the data entry and mandatory fields.

    -  ``feedback``

      Clicking on this button re-directs a user to the `Claim Feedback Page <#claim-feedback-page>`__, where a claim with feedback status **Selected for Feedback** can be feed backed and its current feedback status changed to **Delivered**.

      ..

      The page will open with the current information loaded into the data entry fields. See the `Claim Feedback Page <\l>`__ for information on the data entry and mandatory fields.

    -  ``update``

      Clicking on this button, update the feedback status and review status of claims in the result panel from either **Idle** to **Not Selected** or **Selected for Feedback** or **Selected for Review** respectively or from **Not Selected** to **Selected for Feedback** or **Selected for Review** respectively.

    -  ``process``

      Clicking on this button changes the claim status **Checked** of all current selected claims in the Result Panel, selected by checking the checkbox on the right end of each record, to claim status **Processed**.

      ..

      Claims which can be selected for being processed are ones whose claim status is **Checked** and **Feedback Status** and **Review Status** are not **Idle**. The checkbox on the top of the Result Panel can be used to select multiple claims. The process happens while a user stays on the same page. Once the process is done, a popup window (:ref:`image156`) showing results of the process will be shown.

      .. _image156:
      .. figure:: /img/user_manual/image129.png
        :align: center

        `Image 156 - Process Claim Prompt – Claims Overview Page`

      .. _image157:
      .. figure:: /img/user_manual/image130.png
        :align: center

        `Image 157 - Processed Claims details – Claims Overview Page`

    -  ``Cancel``

      By clicking on the cancel button, the user will be re-directed to the `Claims Overview Page <#claims-overview-page>`__.

  E. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a claim has been reviewed, updated, feedback added on claim or if there was an error at any time during the process of these actions.

Claim Review Page
"""""""""""""""""

  **1. Data Entry**

  .. _image158:
  .. figure:: /img/user_manual/image131.png
    :align: center

    `Image 158 - Claim Review Page`

  ..

    ``Claim Review Page`` will show read-only information of the current claim selected for review, on the top section of the page, on some of the grid columns of the claim services grid and claim items grid and on the bottom of all the grids. As well, the page has input boxes where a user with the role Medical Officer can enter new relevant values for review of the current claim.

    ..

    Read-only information of the current claim includes the following:

    -  ``HF``

      The health facility code and name which the claim belongs to.

    -  ``Main Dg.``

      The code of the main diagnosis.

    -  ``Sec Dg1``

      The code of the first secondary diagnosis.

    -  ``Sec Dg2``

      The code of the second secondary diagnosis.

    -   ``Sec Dg3``

      The code of the third secondary diagnosis.

    -   ``Sec Dg4``

      The code of the fourth secondary diagnosis.

    -  ``Visit type``

      The type of the visit or of the hospital stay (**Emergency, Referral, Other**)

    -  ``Date Processed``

      The date on which the claim was processed (sent to the state **Processed**).

    -  ``Claim Administrator``

      The administrator's code, who was responsible for submission of the current claim.

    -  ``Insurance Number``

      The insurance number of the patient.

    -  ``Claim No.``

      The unique identification of the claim within the claiming health facility.

    -  ``Patient Name``

      The full name of the patient on whom the claim is made.

    -  ``Date Claimed``

      The date on which the claim was prepared by the claiming health facility.

    -  ``Visits Date From``

      The date on which the patient visited (or was admitted by) the health facility for treatment on which the claim is basing on.

    -  ``Visit Date To``

      The date on which the patient was discharged from the health facility for treatment on which the claim is basing on.

    -  ``Guarantee No.``

      Identification of a guarantee letter.

    -  ``Claimed``

      The sum of prices of all claimed services and items at the moment of submission of the claim.

    -  ``approved``

      The value of the claim after automatic checking during its submission and after the corrections of the claim done by a medical officer.

    -  ``Adjusted``

      The value of the claim after automatic adjustments done according to the conditions of coverage by the patient’s policy.

    -  ``Explanation``

      Explanation to the claim provided by the claiming health facility.

    -  ``claim status``

      Claim status is shown on the very bottom right end side after the two grids. This is status which claim gets after submission.

    -  ``rejection reason``

      The last column of each of the two grids, headed with character  '**R**', gives rejection reason number for each of the claimed services or claimed items in the claim services grid or the claim items grid respectively. Rejection reasons are as follows:

    +-----------------------------------+-----------------------------------+
    | Reason Code                       | Reason Description                |
    +===================================+===================================+
    | -1                                | Rejected by a medical officer     |
    +-----------------------------------+-----------------------------------+
    | 0                                 | Accepted                          |
    +-----------------------------------+-----------------------------------+
    | 1                                 | Item/Service not in the registers |
    |                                   | of medical items/services         |
    +-----------------------------------+-----------------------------------+
    | 2                                 | Item/Service not in the           |
    |                                   | pricelists associated with the    |
    |                                   | health facility                   |
    +-----------------------------------+-----------------------------------+
    | 3                                 | Item/Service is not covered by an |
    |                                   | active policy of the patient      |
    +-----------------------------------+-----------------------------------+
    | 4                                 | Item/Service doesn’t comply with  |
    |                                   | limitations on patients           |
    |                                   | (men/women, adults/children)      |
    +-----------------------------------+-----------------------------------+
    | 5                                 | Item/Service doesn’t comply with  |
    |                                   | frequency constraint              |
    +-----------------------------------+-----------------------------------+
    | 6                                 | Item/Service duplicated           |
    +-----------------------------------+-----------------------------------+
    | 7                                 | Not valid insurance number        |
    +-----------------------------------+-----------------------------------+
    | 8                                 | Diagnosis code not in the current |
    |                                   | list of diagnoses                 |
    +-----------------------------------+-----------------------------------+
    | 9                                 | Target date of provision of       |
    |                                   | health care invalid               |
    +-----------------------------------+-----------------------------------+
    | 10                                | Item/Service doesn’t comply with  |
    |                                   | type of care constraint           |
    +-----------------------------------+-----------------------------------+
    | 11                                | Maximum number of in-patient      |
    |                                   | admissions exceeded               |
    +-----------------------------------+-----------------------------------+
    | 12                                | Maximum number of out-patient     |
    |                                   | visits exceeded                   |
    +-----------------------------------+-----------------------------------+
    | 13                                | Maximum number of consultations   |
    |                                   | exceeded                          |
    +-----------------------------------+-----------------------------------+
    | 14                                | Maximum number of surgeries       |
    |                                   | exceeded                          |
    +-----------------------------------+-----------------------------------+
    | 15                                | Maximum number of deliveries      |
    |                                   | exceeded                          |
    +-----------------------------------+-----------------------------------+
    | 16                                | Maximum number of provisions of   |
    |                                   | item/service exceeded             |
    +-----------------------------------+-----------------------------------+
    | 17                                | Item/service cannot be covered    |
    |                                   | within waiting period             |
    +-----------------------------------+-----------------------------------+
    | 18                                | N/A                               |
    +-----------------------------------+-----------------------------------+
    | 19                                | Maximum number of antenatal       |
    |                                   | contacts exceeded                 |
    +-----------------------------------+-----------------------------------+

    -  ``Services and Items data entry grids.``

      1. ``Approved Quantity (app.qty)``

        Enter a number of approved provisions of the corresponding medical service or item.

      2. ``Approved Price (app. price)``

        Enter an approved price of the corresponding medical service or item.

      3. ``justification``

        Enter justification for the entered corrections of the price and quantity of the medical service or item.

      4. ``status``

        Select either the status in the claim **Passed** or **Rejected** for the corresponding medical service or item respectively.

    -  ``Adjustment``

      Enter a text summarizing adjustments in claim done by a medical officer.

  **2. Saving**

  Once appropriate data is entered, clicking on the ``Save`` button will save the claim. The user will be re-directed back to the `Claims Overview Page <#claims-overview-page>`__\; a message confirming that the claim has been saved will appear on the Information Panel. The ``Save`` button appears only if the claim was reviewed in the status **Selected for Review.**

  **3. reviewing**

  Once appropriate data is entered, clicking on the ``Reviewed`` button will save the claim and change the claim Review Status from **Selected for Review** to **Review**. The user will be re-directed back to the `Claims Overview Page <#claims-overview-page>`__\; a message confirming that the claim has been saved will appear on the Information Panel. The ``Reviewed`` button appears only if the claim was reviewed in the status **Selected for Review**.

  **4. data entry validation**

  If inappropriate data is entered at the time the user clicks the ``Save`` or `` review`` button, an error message will appear in the Information Panel, and the data field will take the focus.

  **5. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Claims Overview Page <#claims-overview-page>`__\.

Claim Feedback Page
"""""""""""""""""""

  **1.  Data Entry**

  .. _image159:
  .. figure:: /img/user_manual/image132.png
    :align: center

    `Image 159 - Claim Feedback Page`

  ..

    ``Claim Feedback Page`` will show read-only information of the current claim selected for feedback, on the top section of the page it has input boxes where a user with the role Medical Officer can enter feedback on the current claim or where the user can read a feedback delivered by enrolment officers.

    ..

    Read-only data of the feedback includes in the section **Claim** the following:

    -  ``HF Code``

      The health facility code which the claim belongs to.

    -  ``HF Name``

      The health facility name which the claim belongs to

    -  ``Claim Administrator``

      The administrator's code, who was responsible for submission of the current claim.

    -  ``Insurance Number``

      The insurance number of the patient.

    -  ``Claim No.``

      The unique identification of the claim within the claiming health facility.

    -  ``Last Name``

      The last name of the patient on whom the claim is made.

    -  ``Other Names``

      The other names of the patient on whom the claim is made.

    -  ``Date Claimed``

      The date on which the claim was prepared by the claiming health facility.

    -  ``Visits Date From``

      The date on which the patient visited (or was admitted by) the health facility for treatment on which the claim is basing on.

    -  ``Visit Date To``

      The date on which the patient was discharged from the health facility for treatment on which the claim is basing on.

    -  ``Review Status``

      The status of the claim with respect to reviewing.

    -  ``Feedback Status``

      The status of the claim with respect to feed backing.

    Modifiable data of the feedback include sin the section **Feedback** the following

    -  ``Enrolment Officer``

      Select an enrolment officer from the list of enrolment officers, by clicking the arrow on the right side of selection field. The enrolment officer collects feedback from the patient.

    -  ``Care Rendered``

      Select ‘Yes’ or ‘No’ from the list, by clicking the arrow on the right side of selection field.

    -  ``Payment Asked``

      Select ‘Yes’ or ‘No’ from the list, by clicking the arrow on the right side of selection field.

    -  ``Drugs Prescribed``

      Select ‘Yes’ or ‘No’ from the list, by clicking the arrow on the right side of selection field.

    -  ``Drugs Received``

      Select ‘Yes’ or ‘No’ from the list, by clicking the arrow on the right side of selection field

    -  ``Overall Assessment``

      Choose one level among the six levels available by checking/clicking on the desired checkbox.

    -  ``Feedback Date``

      Type in a date of collection of the feedback; or use the date selector button, to enter date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the back space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image160`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of today.
        -  Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image160:
      .. |logo39| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo40| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo41| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo39| || |logo40| || |logo41| |
      +----------++----------++----------+

        `Image 160 - Calendar Selector - Search Panel`

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the feedback on current claim. The user will be re-directed back to the `Claims Overview Page <#claims-overview-page>`__\ ; a message confirming that the feedback has been saved will appear on the Information Panel. If inappropriate data is entered or mandatory data is not entered at the time the user clicks the Save button, an error message will appear in the Information Panel, and the data field will take the focus.

  **3. Cancel**

  By clicking on the ``Cancel`` button, the user will be re-directed to the `Claims Overview Page <#claims-overview-page>`__\ .

Batch Run
^^^^^^^^^

Administration of batches of claims is restricted to users with the role of Accountant.

Pre-conditions
""""""""""""""

Navigation
"""""""""""

All functionality for use with the administration of processing of batches can be found under the main menu ``Claims``, sub menu ``Batch Run.``

.. _image161:
.. figure:: /img/user_manual/image133.png
  :align: center

  `Image 161 - Navigation Batch Run`

Clicking on the sub menu ``Batch Run`` re-directs the current user to the `Batch Run Control Page <#_Batch_Run_Control>`__\ .

Batch Run Control Page
""""""""""""""""""""""

.. _image162:
.. figure:: /img/user_manual/image134.png
  :align: center

`Image162 (Batch Run Control Page)`

The Batch Run Control Page is the central point for batch processing administration. Access to the page is restricted to users with the role of Accountant. By having access to this page, it is possible to process batches, filter, and filter for accounts. The panel is divided into six sections `(Image 5.28) <#image-5.28-batch-run-control-page>`__

  A. Batch Processing Panel.

  The batch processing panel allows a user to process batches based on the following criteria:

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select a region. *Note: The list will only be filled with the regions assigned to the current logged in user and the option National.*

    -  ``District``

      Select the ``district``; from the list of districts by clicking on the arrow on the right of the selector to select a district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected. If no district is selected then the processing is done only for insurance product defined for the selected region.*

    -  ``Month``

      Select the ``month``; from the list of months by clicking on the arrow on the right of the selector.

    -  ``Year``

      Select the ``Year``; from the list of available years by clicking on the arrow on the right of the selector. Only periods for which a batch hasn’t been run yet are offered in both lists.

    -  ``process``

      Once criteria are chosen, clicking on this process button, will process based on the selected criteria. If the option **National** was used in the field ``Region`` the batch is run only for nationwide insurance products. If a region is selected in the field ``Region`` and no district is selected the batch is run only for regional insurance products for the selected region. If a district is selected in the field district the batch is run only for district insurance products for the selected district.

  B. Filter Panel.

  The filter panel allows a user to filter results of running of batches (calculation of indexes for relative pricing) based on the following criteria:

    -  ``Type``

      Select the ``Type``; from the list of time group types (**Monthly, Quarterly, Yearly**) by clicking on the arrow on the right of the selector.

    -  ``Year``

      Select the ``Year``; from the list of available years by clicking on the arrow on the right of the selector.

    -  ``Period``

      Select the ``Period``; from the list of months/quarters by clicking on the arrow on the right of the selector.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select a region. *Note: The list will only be filled with the regions assigned to the current logged in user and the option National.*

    -  ``District``

      Select the District; from the list of districts by clicking on the arrow on the right of the selector to select a district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected*

    -  ``Product``

      Select Product from the list of products by clicking on the arrow on the right of the selector.

    -  ``Category``

      Select category of health care (**Hospital, Non-hospital, General**) from the list of categories of health care by clicking on the arrow on the right of the selector.

    -  ``Filter``

      Once criteria are chosen, clicking on this filter button will filter based on the selection criteria.

  C. Display Panel.

  The Display Panel is used to display results of running of batches after the filter or processing. While hovering over records, records get highlighted with a yellow colour (:ref:`image163`).

  .. _image163:
  .. figure:: /img/user_manual/image135.png
    :align: center

    `Image 163 - Selected record (blue), hovered records (yellow) - Result Panel`

..

  D. Filter for Accounts Panel.

  The Filter for Accounts Panel is used in filtering of batch protocols for an accounting system based on the following criteria:

    -  ``Start Date``

      Type in a date; or use the Date Selector Button to enter date which is equal or less than claim date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``End Date``

      Type in a date; or use the Date Selector Button to enter date which is equal or greater than claim date. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image164`); by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        - At anytime during the use of the pop-up, the user can see the date of today.
        - Clicking on today will close the pop-up and display the today’s date in the corresponding date entry box.
        - Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        - Clicking on the arrow to the left displays the previous month.
        - Clicking on the arrow on the right will displays the following month.
        - Clicking on the month will display all the months for the year.
        - Clicking on the year will display a year selector.

        .. _image164:
        .. |logo40| image:: /img/user_manual/image6.png
          :scale: 100%
          :align: middle
        .. |logo41| image:: /img/user_manual/image7.png
          :scale: 100%
          :align: middle
        .. |logo42| image:: /img/user_manual/image8.png
          :scale: 100%
          :align: middle

        +----------++----------++----------+
        | |logo40| || |logo41| || |logo42| |
        +----------++----------++----------+

          `Image 164 - Calendar Selector - Search Panel`

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select a region. **Note: The list will only be filled with the regions assigned to the current logged in user and the option National.*

    -  ``District``

      Select the ``district``; from the list of districts by clicking on the arrow on the right of the selector to select a district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the District will be automatically selected*

    -  ``HF``

      Select a health facility from the list of health facilities codes and names clicking on the arrow on the right of the selector. *Note: The list will only be filled with the Health Facilities belonging to the Districts assigned to the current logged in user.*

    -  ``Product``

      Select a product from the list of products by clicking on the arrow on the right of the selector. The list of products contains only nationwide insurance products if the option **National** is used in the field Region. It contains only regional insurance products for the selected region if no district is selected. It contains only district insurance products for the selected district.

    -  ``Level``

      Select a level from the list of levels of health facilities by clicking on the arrow on the right of the selector.

    -  ``Group By``

      Select either grouping of the report by health facility (``HF``) or by product (``Product``) by checking either the health facility checkbox or product checkbox respectively.

    -  ``Show All``

      Check this checkbox, if you need to show all health facilities in the report although they have no claim included.

    -  ``Show Claims``

      Check this checkbox, if you need to show all claims in detailed way in the protocol.

    -  ``Preview``

      Once criteria are chosen, clicking on this preview button will create a protocol of the selected batch.

  E. Button Panel

  This panel contains control button.

    -  ``Cancel``

      By clicking on the cancel button, the user will be re-directed to the `Home Page <#image-2.2-home-page>`__.

  F. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a batch has been processed, filtered or if there was an error at any time during the process of these actions.

Tools
-----

Upload List of Diagnoses
^^^^^^^^^^^^^^^^^^^^^^^^

Access to uploading of diagnoses is restricted to the users with the role of IMIS Administrator.


Navigation
""""""""""

All functionality for use with the administration of uploading of the list of diagnoses can be found under the main menu ``Tools``, sub menu ``Upload Diagnoses``.

.. _image165:
.. figure:: /img/user_manual/image136.png
  :align: center

  `Image 165 - Navigation Upload Diagnoses`

Clicking on the sub menu ``Upload Diagnoses`` re-directs the current user to the `Upload Diagnoses Page <#image-6.2-upload-diagnoses-page>`__\.

.. _image166:
.. figure:: /img/user_manual/image137.png
  :align: center

  `Image 166 - Upload Diagnoses Page`

The Upload Diagnoses Page is divided into three sections (:ref:`image166`).

  A. Select Criteria

  The Select Criteria allows the user to choose file containing diagnoses codes; that should be uploaded. Also a user can select the option whether or not to delete existing codes, if the code is not in the source file. The source file containing the uploaded list of diagnoses is a **txt** file having in the title (first) row (items separated by a **Tab** character):

  ..

  CDCode  ICDName

  ..

  And on each subsequent row is the code of one diagnosis and its name separated by a **Tab** character

  B. Buttons

    -  ``Upload``

      By clicking on the Upload button, a prompt popup message will appear, require a user to agree or disagree (:ref:`image167`). If user agrees the selected file containing list of diagnoses will be uploaded.

      .. _image167:
      .. figure:: /img/user_manual/image138.png
        :align: center

        `Image 167 - Upload Diagnoses`

    -  ``Cancel``

      By clicking on ``Cancel`` button, user will be re-directed to `Home page <#image-2.2-home-page>`__.

  C. Information Panel

  The Information Panel is used to display messages back to the user.

Policy Renewals
^^^^^^^^^^^^^^^

Access to management of policy renewals is restricted to the users with the role of Clerk.

Navigation
""""""""""

All functionality for use with the administration of policy renewals can be found under the main menu ``Tools``, sub menu ``Policy Renewals``

.. _image168:
.. figure:: /img/user_manual/image139.png
  :align: center

  `Image 168 - Navigation Policy Renewals`

Clicking on the sub menu ``Policy Renewals`` re=directs the current user to the `Policy Renewal Page <#policy-renewal-page>`__\.

.. _image169:
.. figure:: /img/user_manual/image140.png
  :align: center

  `Image169 - Policy Renewal Page`

Policy Renewal Page
"""""""""""""""""""

By having access to this page, it is possible preview the report on policy renewals, preview the journal on policy renewals and update the status of a policy. The journal will contain information on actual prompts being generated by the system. These prompt could already have been sent to the mobile phones of enrolment officers. The report on policy renewals will contain information on the expiration of policies for any given period. The page is divided into two panels (:ref:`image169`).

  A. Select Criteria Panel

  The Select Criteria Panel or the filter panel allows a user to select specific criteria to minimise the report on policy renewals.

  ..

  Two tasks are carried out by this form. 1) Preview the report on policy renewal and 2) Preview the journal on policy renewal. Depending on the selected option, filter will be changed accordingly.

  ..

  If Preview option is selected then a user has the following filters.

    -  ``Policy Status``

      Select the policy status from the drop down list by clicking on the right arrow. By selecting any of the options a user can filter the report on particular status of the policy. This filter is not mandatory. User can leave it blank to preview the report on any status.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select policies from a specific region. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

    -  ``District``

      Select the ``district``; from the list of districts by clicking on the arrow on the right of the selector to select policies from a specific district. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.*

    -  ``Municipality``

      Select the ``Municipality``; from the list of municipalities by clicking on the arrow on the right of the selector to preview report from a specific district. *Note: The list will only be filled with the municipalities that belong to the selected district. If this is only one then the municipality will be automatically selected.*

    -  ``Village``

      Select the ``village``; from the list of villages by clicking on the arrow on the right of the selector to preview report from a specific village. *Note: The list will only be filled with the villages that belong to the selected municipality.*

    -  ``Enrolment Officer``

      Select the ``Enrolment Officer``; from the list of enrolment officers by clicking on the arrow on the right of the selector to preview the report for the specific officer. *Note: The list will only be filled with the enrolment officers belonging to the districts assigned to the current logged in user. If this is only one then the enrolment officer will be automatically selected.*

    -  ``Date From``

      By clicking on the button next to the ``Date From`` data field a calendar will pop up. Click on his desired date and the textbox will be filled with the selected date. This is a mandatory field. Only the policies for renewal date greater than or equal to the ``Date From`` will be previewed.

    -  ``Date To``

      By clicking on the button next to the ``Date To`` data field a calendar will pop up. Click on his desired date and the textbox will be filled with the selected date. This is a mandatory field. Only the policies for renewal date less than or equal to the ``Date To`` will be previewed.

  When previewing the journal; the ``Policy Status`` filter will be replaced with ``SMS Status`` and there will be one more additional filter, ``Journal On``.

    -  ``SMS Status``

    Select the ``SMS status`` from the drop down list by clicking on the right arrow. By selecting any of the options the user can filter the journal on a particular ``SMS status``. This filter is not mandatory. By leaving it blank all journals will be displayed.

    -  ``Journal On``

    Select the ``journal On`` from the drop down *list* by clicking on the right arrow, to filter the journal either on prompt or on expiry of the prompt.

  B. Button Panel

  ``Cancel:`` Re-directs to the `Home Page <#image-2.2-home-page>`__

  ``Preview:`` Click on the preview button to display the report based on the filters.

  ``Update:`` Click on this button to manually update the status of the policy on the current day. Although this task is carried out by the **IMIS Policy Renewal Service** running on the server at specific intervals of time, this button enables the task to be run manually.

  C. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur once a user has updated the policy status or if there was an error at any time during the process of these actions.

  .. _image170:
  .. figure:: /img/user_manual/image141.png
    :align: center

    `Image170 - Policy Renewal updated successfully message`

Preview Report on Renewals
""""""""""""""""""""""""""

.. _image171:
.. figure:: /img/user_manual/image142.png
  :align: center

  `Image 171 - Preview Report on Renewals`

After selecting specific criteria; preview the report (:ref:`image171`) by clicking on the preview button.

Preview Journal on Renewals
"""""""""""""""""""""""""""

Just like preview of the policy renewals the journal report can also be previewed. The difference between the Policy Renewal report and the Journal is; one forecasts the renewal while the other gives a report on the status of the renewal. Below is an example of a Journal Report.

.. _image172:
.. figure:: /img/user_manual/image143.png
  :align: center

  `Image 172 - Preview Journal on Renewals`

Feedback Prompts
^^^^^^^^^^^^^^^^

Access to administration of feedback prompts is restricted to the users with the role of Medical Officer.

Navigation
""""""""""

All functionality for use with the administration of feedback prompt can be found under the main menu ``Tools``, sub menu ``Feedback Prompts``

.. _image173:
.. figure:: /img/user_manual/image144.png
  :align: center

  `Image 173 - Navigation Feedback Prompts`

Clicking on the sub menu ``Feedback Prompts`` re-directs the current user to the `Feedback Prompt Page <#image-6.9-feedback-prompts-page>`__\.

.. _image174:
.. figure:: /img/user_manual/image145.png
  :align: center

  `Image 174 - Feedback Prompts Page`

The Feedback Prompt Page is divided into three panels (:ref:`image174`).

  A. Select Criteria Panel

  The Select Criteria Panel or the filter panel allows a user to select specific criteria for feedback.

    -  ``SMS Status``

      Select ``SMS Status`` from the list

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select a specific region for feedbacks. *Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.*

    -  ``District``

      Select the ``district`` from the list of districts by clicking on the arrow on the right of the selector to select district for feedbacks. *Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the District will be automatically selected.*

    -  ``Municipality``

      Select the ``Municipality`` from the list of municipalities you wish to prompt for feedbacks. *Note: The list will only be filled with the municipalities that belong to the selected district. If this is only one then the municipality will be automatically selected.*

    -  ``Village``

      Select the ``village``; from the list of villages you wish to prompt for feedbacks. *Note: The list will only be filled with the villages that belong to the selected municipality.*

    -  ``Enrolment Officer``

      Select the ``Enrolment Officer``; from the list of enrolment officers by clicking on the arrow on the right of the selector to preview the report for the specific officer. *Note: The list will only be filled with the enrolment officers belonging to the districts assigned to the current logged in user. If this is only one then the enrolment officer will be automatically selected.*

    -  ``Start Date``

      Type in a date; or use the Date Selector Button, to enter the ``Start Date`` for feedbacks. *Mandatory. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``End Date``

      Type in a date; or use the Date Selector Button, to enter the ``End Date`` for feedbacks. *Mandatory*. *Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.*

    -  ``Send SMS``

      By Clicking ``Send SMS`` button, user actually sends an SMS. When an SMS is sent successfully as message will be given. If failed to be sent, a failure message will appear.

  B. Buttons Panel

    -  ``Preview``

      By clicking on the ``Preview`` button, a report (journal) of feedbacks prompted will get generated and displayed (:ref:`image175`).

    -  ``Cancel``

      By clicking on ``Cancel`` button, user will be re-directed to `Home Page <#image-2.2-home-page>`__.

  .. _image175:
  .. figure:: /img/user_manual/image146.png
    :align: center

    `Image 175 - Feedback Prompt Journal`

  C. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur if there was an error at any time during the processing of the reports.

IMIS Extracts
^^^^^^^^^^^^^

Access to the IMIS Extracts page is restricted to users with the role of Scheme Administrator (IMIS Central online) or HF Administrator (IMIS offline installations). This page will contain all functionality for data synchronization between IMIS Central and IMIS offline installations as well as the generation of extract files for the mobile phones (Android). Depending on the type of installation, the interface will enable and disable certain functions.

Pre-conditions
""""""""""""""

The extract functionality is covering extracts for the mobile phone applications and the IMIS ‘off-line’ installations. IMIS offline extracts are only to be generated in case a district has so called ‘off-line’ installations in areas where no Internet connectivity is available.

..

Extracts are to be downloaded to the local PC that is initiating the creation of the extract.

..

Standard procedures should be formulated to stipulate the time interval between Extract creations and the management of transporting and installing/transferring these extracts into the target environment: mobile phones or offline IMIS clients.

Navigation
""""""""""

All functionality related to IMIS extracts can be found under the main menu ``Tools``, sub menu ``IMIS Extracts``

.. _image176:
.. figure:: /img/user_manual/image147.png
  :align: center

  `Image 176 - Navigation IMIS Extracts`

Clicking on the sub menu ``IMIS Extracts`` re-directs the current user to the ``IMIS Extracts Page.``

..

This page opens in two different modes depending on the type of IMIS installation: IMIS Central (live server) or IMIS offline (installed on local network in a health facility or an office of the scheme administration).

IMIS Extracts (ONLINE MODE)
"""""""""""""""""""""""""""

.. _image177:
.. figure:: /img/user_manual/image148.png
  :align: center

  `Image 177 - IMIS Extracts`

**A - Phone Extract panel**

The Phone extract panel is used for the generation of so called SQLite database files for the mobile phone applications. Each district will have its own phone extract file that needs to be distributed to the mobile phones within the district. To generate a phone extract file, the operator has to select a region and a district from the list of available districts. In case the user is having access to its own district only, the district will be automatically selected and shown on the display.

..

By clicking the ``Create`` button in panel A, a phone extract will be created. This process might take a while. As long as the hour glass (as a cursor) is shown, IMIS is still processing the file. The file size depends on the amount of photographs included in the extract. The file size could range into hundreds of MBs. To alleviate this problem two options are available:

    -  ``With Insurees``

      Checking this box means that a complete phone extract (including photos) will be generated. Leaving it unchecked a shortened phone extract without photos will be generated.

    -  ``In background``

      Checking this box means that the phone extract will be created in background and the user will be notified by e-mail (provided his/her e-mail is entered in the register of users).

In case the extract is created in the background, the following dialog box appears:

.. _image178:
.. figure:: /img/user_manual/image149.png
  :align: center

  `Image 178`

If the extract is not created in background the user is notified about successful creation by the following message as shown below.

.. _image179:
.. figure:: /img/user_manual/image150.png
  :align: center

  `Image 179`

The extract will be downloaded to your local computer by clicking the ``Download`` link that will appear after the creation of the extract, as shown below.

.. _image180:
.. figure:: /img/user_manual/image151.png
  :align: center

  `Image 180`

The extract file is called **IMISDATA.DB3** and needs first to be copied (downloaded) to the local machine. After clicking the ``Download`` button, the operator is able to select the destination folder (locally) for the file to download as shown below.

.. _image181
.. figure:: /img/user_manual/image152.png
  :align: center

  `Image 181`

The extract is now ready to be transferred/copied to the mobile phones. This process is performed manually by connecting the mobile phone to the computer with the provided USB cable. The user needs to copy, manually, the file from the local machine into the ‘IMIS’ Folder on the mobile phone.

**B - Offline Extract panel**

The offline extract panel is used to generate the IMIS ‘offline’ extract files for the health facilities or offices of the scheme administration that run IMIS offline. To generate an offline extract file, the operator has to select a region and a district from the list of available districts. In case the user is having access to its own district only, the district will be automatically selected and shown on the display. When an operator belongs to one specific district, the district box is already selected with the district of the user. To create a new extract, the operator needs to click the ``Create`` button (in panel B).

..

Three types of extracts could be generated:

    -  Differential Extract ``(Download D)``

      Differential extracts will only contain the differences in data compared with the previous extract. The first differential extract (sequence 000001) will contain all data as it will be the first extract. Thereafter, this type of the extract, will only contain any differences after the previous extract. This will result in smaller files sent to the health facilities in off-line mode. When we click the create button, the differential extract is always generated and will be assigned the next sequence number. A separate Photo extract will be created containing only photographs linked to changes compared with the previous extract. Differential extracts with insure and policy data are only generated in case the ``With Insuree`` checkbox is checked as shown below.

      .. _image182
      .. figure:: /img/user_manual/image153.png
        :align: center

        `Image 182`

    -  Full extract ``(Download F)``

      The Full extract will always contain all information in the database. These extracts are only generated in case the ``Full extract`` and the ``With Insuree`` checkbox are checked as shown below.

      .. _image183
      .. figure:: /img/user_manual/image154.png
        :align: center

        `Image 183`

      By clicking the ``Create`` button, in case of ``Full extract`` is checked, two extracts will be generated, one differential extract and one full extract. Both extracts will have the same sequence number. This implies that full extracts are not always needed/generated. A separate photo extract will be created containing all photographs.

    -  Empty Extract ``(Download E)``

      Empty extracts will only contain the data from registers and no data on insurees and their policies/photos. If a full set of register data should be included in the extract, the checkbox ``Full extract`` has to be checked as shown below.

      .. _image184
      .. figure:: /img/user_manual/image155.png
        :align: center

        `Image  184`

After clicking the ``Create`` button, the system will create the extract file and will on completion display the following message:

.. _image185
.. figure:: /img/user_manual/image156.png
  :align: center

  `Image 185`

The message is only shown to provide some details on how much information is exported to the extract file.

..

Depending on the ``Full extract`` option, we will be re-directed to the extract page and will see the newly generated extract sequence in the list or will get a new message as shown below:

.. _image186
.. figure:: /img/user_manual/image157.png
  :align: center

  `Image 186`

After clicking OK the statistics of the full extract will be shown:

.. _image187
.. figure:: /img/user_manual/image158.png
  :align: center

  `Image 187`

We are now ready to download the extract to our computer.

..

The combo box next to the district selector contains information on all generated extracts with the sequence number and date. (e.g. Sequence 000007 – Date 06-09-2012). If the extract selector does not show any entries (blank) it means that no previous extracts were created. At least one full extract needs to be generated. This is needed to initialise a new offline IMIS installation.

..

To download the actual extracts, the operator needs to select the desired extract sequence from the list of available extracts.

..

Four different types of extracts could be downloaded by clicking one of the following buttons:

    -  ``Download D`` (Differential extract)

      -  Will download the selected differential extract with the following filename

        *Filename: OE_D_<DistrictID>_<Sequence>.RAR (e.g. OE_D_1_8.RAR)*

    -  ``Download F`` (Full extract)

      -  Will download the latest full extract with the following filename

        *Filename: OE_F_<DistrictID>_<Sequence>.RAR (e.g. OE_F_1_8.RAR)*

    -  ``Download E`` (Empty extract)

      -  Will download the latest full extract with the following filename

        *Filename: OE_E_<DistrictID>_<Sequence>.RAR (e.g. OE_F_1_8.RAR)*

    -  ``Download Photos D`` (Differential Photo extract)

      -  Will download the selected differential photo extract with filename:

        *Filename: OE_D_<DistrictID>_<Sequence>.RAR (e.g. OE_D_1_8_Photos.RAR)*

    -  ``Download Photos F`` (Full Photo extract)

      -  Will download the latest FULL photo extract with the following filename

        *Filename: OE_D_<DistrictID>_<Sequence>.RAR (e.g. OE_F_1_8_Photos.RAR)*

After clicking the desired extract download button, the file download dialog box appears to select the destination folder for the extract file as shown below:

.. _image188
.. figure:: /img/user_manual/image159.png
  :align: center

  `Image 188`

In case the extract file is not available (anymore) on the server, the following dialog box might appear:

.. _image189
.. figure:: /img/user_manual/image160.png
  :align: center

  `Image 189`

The reason for this box to appear could be that the file to be downloaded has been removed from the server or that you have attempted the download a full extract but no full extract was generated (only the differential extracts exist). It is also possible that you have attempted to download a photo extract but no photos were added since the last extract.

..

Checking the checkbox ``In background`` means that the off-line extract will be created in background and the user will be notified by e-mail (provided his/her e-mail is entered in the register of users) as shown below:

.. _image190
.. figure:: /img/user_manual/image161.png
  :align: center

  `Image 190`

In case the extract is created in the background, the following dialog box appears:

.. _image191
.. figure:: /img/user_manual/image149.png
  :align: center

  `Image 191`

**C - Import Extract panel**

This panel will be disabled in the IMIS online mode. (Only available for IMIS offline)

**D - Import Photos panel**

This panel will be disabled in the IMIS online mode. (Only available for IMIS offline)

**E - Button panel**

The ``Cancel`` button brings the operator back to the `Home Page <#image-2.2-home-page>`__.

**F - Information panel**

The Information Panel is used to display messages back to the user. Messages will occur once an action has completed or if there was an error at any time during the process of these actions.

IMIS Extracts (OFFLINE MODE)
""""""""""""""""""""""""""""

**Offline HF**

.. _image192
.. figure:: /img/user_manual/image162.png
  :align: center

  `Image 192`

**A - Import Extract**

Used to extract photos obtained from online IMIS

**B - Import Photos**

Used to upload photos obtained from online IMIS

**C - Download Claim XMLs**

Used to download claims made in the offline health facility prior to be sent to online IMIS

**Offline Insurer**

.. _image193
.. figure:: /img/user_manual/image163.png
  :align: center

  `Image 193`

**A - Import Extract**

Used to upload extract obtained from online IMIS

**B - Import Photos**

Used to upload photos obtained from online IMIS

**C - Import Extract**

The Choose file section should be clicked to select an extract file to upload/import. The following file selector appears for Internet explorer (the appearance might differ for different internet browsers):

.. _image194
.. figure:: /img/user_manual/image164.png
  :align: center

  `Image 194`

On clicking the ``Choose File`` button, the file selector dialog appears as shown below:

.. _image195
.. figure:: /img/user_manual/image165.png
  :align: center

  `Image 195`

With the import/upload of an extract it is important to understand that each extract has its sequence number. This sequence number is found in the filename of the extract. We would in case of differential imports/uploads have to follow the sequence. In the example screen above, it shows in the status bar, that the last import was number 6. Therefore we should select in this case the differential extract number 7 as highlighted in the file selection dialog.

..

Alternatively the operator could select any full extract with a sequence number higher than 6. In case a wrong extract is selected, warning messages will appear as shown below:

.. _image196
.. figure:: /img/user_manual/image166.png
  :align: center

  `Image 196`

or

.. _image197
.. figure:: /img/user_manual/image167.png
  :align: center

  `Image 197`

In case you are missing extract sequences, additional extracts are needed to be uploaded before the extract selected. The extract selected, in this case, does not directly follow the last sequence as indicated in the status bar of the screen. The additional extracts are to be provided by NSHIP district office.

..

In case the extract file selected is valid, the system will import the data. New data will be added and existing data might be modified. After a successful import of an extract (Differential and FULL), a form is displayed with the statistics of the import as shown below:

.. _image198
.. figure:: /img/user_manual/image168.png
  :align: center

  `Image 198`

The above statistics are provided to give some quick overview of how many records were inserted or updated during the import process. In case we would for example update the phone number of an enrolment officer, it would result in one update and one insert as we always keep historical records. The photos inserts and updates are related to information on the photos, but are not the actual photographs. The actual photographs (*.jpg) are uploaded separately.

**D - Import Photos**

The import of photos is optional and will have no further checking on sequence numbers. NSHIP should provide (if available) with each extract the photo extract as well.

..

E.g. (for Differential extract)

.. _image199
.. figure:: /img/user_manual/image169.png
  :align: center

 `Image 199`

OR (for FULL extract)

.. _image200
.. figure:: /img/user_manual/image170.png
  :align: center

  `Image 200`

The photo extract will contain all photographs associated with the actual extract in a zipped format. The Upload procedure will simply unzip the extract and copy the image files to the photo folder of IMIS.

..

After successful upload of the photographs the following message appears:

.. _image201
.. figure:: /img/user_manual/image171.png
  :align: center

  `Image 201`

**E - Button panel**

The ‘Cancel’ button brings the operator back to the main page of IMIS.

**F - Information panel**

The Information Panel is used to display messages back to the user. Messages will occur once an action has completed or if there was an error at any time during the process of these actions. If the user opens the IMIS extracts page (in offline mode only), the status bar will show the last sequence number uploaded.

Reports
^^^^^^^

Access to the reports is generally restricted to the users with the role of Manager, Accountant, Scheme Administrator and IMIS Administrator. By having access to the ``Reports Page``, it is possible to generate several operational reports. Each report can be generated by users with a specific role (Manager, Accountant, Scheme Administrator and IMIS Administrator) only.

Pre-Conditions
""""""""""""""

Navigation
"""""""""""

All functionality for use with the administration of Reports can be found under the main menu ``Tools``, sub menu ``Reports.``

.. _image202
.. figure:: /img/user_manual/image172.png
  :align: center

  `Image 202 - Navigation Reports`

Clicking on the sub menu ``Reports`` re-directs the current user to the Reports Page (:ref:`image203`).

.. _image203
.. figure:: /img/user_manual/image173.png
  :align: center

  `Image 203 - Reports Page`


The Reports Page is divided into four panels (:ref:`image203`).

  A. Select Criteria

  The Select Criteria panel or the filter panel allows a user to select specific criteria determining the scope of data included in the report. The criteria (:ref:`image204 – 221`) will change depending on the selected type of the report.

    -  Primary Operational Indicators - Policies Report.

    .. _image204
    .. figure:: /img/user_manual/image174.png
      :align: center

      `Image 204 - Primary Operational Indicators - Policies Report Criteria`

    -  Primary Operational Indicators - Claims Report.

    .. _image205
    .. figure:: /img/user_manual/image175.png
      :align: center

      `Image 205 - Primary Operational Indicators - Claims Report Criteria`

    -  Derived Operational Indicators Report.

    .. _image206
    .. figure:: /img/user_manual/image176.png
      :align: center

      `Image 206 - Derived Operational Indicators Report Criteria`

    -  Contribution Collection Report.

    .. _image207
    .. figure:: /img/user_manual/image177.png
      :align: center

      `Image 207 - Contribution Collection Report Criteria`

    -  Product Sales Report.

    .. _image208
    .. figure:: /img/user_manual/image178.png
      :align: center

      `Image 208 - Product Sales Report Criteria`

    -  Contribution Distribution Report.

    .. _image209
    .. figure:: /img/user_manual/image179.png
      :align: center

      `Image 209 - Contribution Distribution Report Criteria`

    -  User Activity Report.

    .. _image210
    .. figure:: /img/user_manual/image180.png
      :align: center

      `Image 210 - User Activity Report Criteria`

    -  Enrolment Performance Indicator Report.

    .. _image211
    .. figure:: /img/user_manual/image181.png
      :align: center

      `Image 211 - Enrolment Performance Indicators Report Criteria`

    -  Status of Registers Report.

    .. _image212
    .. figure:: /img/user_manual/image182.png
      :align: center

      `Image 212 - Status of Registers Report Criteria`

    -  Insurees without Photos Report.

    .. _image213
    .. figure:: /img/user_manual/image183.png
      :align: center

      `Image 213 - Insurees without photos Report Criteria`

    -  Payment Category Overview Report.

    .. _image214
    .. figure:: /img/user_manual/image184.png
      :align: center

      `Image 214 - Payment Category Overview Report Criteria`

    -  Matching Funds Report.

    .. _image215
    .. figure:: /img/user_manual/image185.png
      :align: center

      `Image 215 - Matching funds Report Criteria`

    -  Claim Overview Report.

    .. _image216
    .. figure:: /img/user_manual/image186.png
      :align: center

      `Image 216 - Claim Overview Report Criteria`

    -  Percentage of Referrals Report.

    .. _image217
    .. figure:: /img/user_manual/image187.png
      :align: center

      `Image 217 - Percentage of Referrals Report Criteria`

    -  Families and Insurees Overview Report.

    .. _image218
    .. figure:: /img/user_manual/image188.png
      :align: center

      `Image 218 - Families and Insurees Overview Report Criteria`

    -  Pending Insurees Report.

    .. _image219
    .. figure:: /img/user_manual/image189.png
      :align: center

      `Image 219 - Pending Insurees Report Criteria`

    -  Renewals Report.

    .. _image220
    .. figure:: /img/user_manual/image190.png
      :align: center

      `Image 220 Renewals Report Criteria`

    -  Capitation Payment Report

    .. _image221
    .. figure:: /img/user_manual/image191.png
      :align: center

      `Image 221 Capitation Payment Report Criteria`

The general meaning of selection criteria for creating of a report is as follows:

    -  ``Date From``

      Type in a date; or use the Date Selector Button, to enter the beginning of a period, in which policies have their enrolment, effective, expire or renewal days, contributions were paid or in claimed health care was provided. If used with a report, it is mandatory. `*Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.`*

    -  ``Date To``

      Type in a date; or use the Date Selector Button, to enter the end of a period, in which policies have their enrolment, effective, expire or renewal days or in which claimed health care was provided. If used with a report, it is mandatory. `*Note. To clear the date entry box; use the mouse to highlight the full date and then press the space key.`

    -  ``Payment Type``

      Select the ``Payment Type`` from the drop down list by clicking on the right arrow. By selecting any of the options a user can filter the report on a particular type of the payment. This filter is not mandatory, leave it blank to preview the report on all the payment modes.

    -  ``Region``

      Select the ``Region``; from the list of regions by clicking on the arrow on the right of the selector to select a region, data of which should be included for the report. `*Note: The list will only be filled with the regions assigned to the current logged in user. If this is only one then the region will be automatically selected.`*

    -  ``District``

      Select the ``District``; from the list of districts by clicking on the arrow on the right of the selector to select a district, data of which should be included for the report. `*Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user. If this is only one then the district will be automatically selected.`*

    -  ``Product``

      Select the ``Product``; from the list of products by clicking on the arrow on the right of the selector to include in the report data for the specific product. `*Note: The list will only be filled with the products belong to the districts assigned to the current logged in user. If this is only one then the product will be automatically selected.`*

    -  ``Month``

      Select the ``Month`` from the list of months by clicking on the arrow on the right of the selector to include in the report data relating to that month selected.

    -  ``Year``

      Select the ``year`` from the list of years by clicking on the arrow on the right of the selector to include in the report data relating to that year selected.

    -  ``Quarter``

      Select the ``quarter`` from the list of quarters by clicking on the arrow on the right of the selector to include in the report data relating to that quarter selected.

    -  ``HF Code``

      Select the ``HF Code``; from the list of heath facility codes by clicking on the arrow on the right of the selector to create the report for the specific health facility. `*Note: The list will only be filled with health facility codes of health facilities belonging to the districts assigned to the current logged in user. If this is only one then the health facility code will be automatically selected.`*

    -  ``Enrolment Officer``

      Select the enrolment officer; from the list of enrolment officers by clicking on the arrow on the right of the selector to select enrolment officer data of whom should be included in the report. `*Note: The list will only be filled with the enrolment officers assigned to the current selected district. If this is no district selected the enrolment officers list will be filled by all districts' enrolment officers`*

    -  ``Payer``

      Select the payer from the drop down list by clicking on the right arrow. By selecting any of the options a user can filter the report on a particular payer. This filter is not mandatory; leave it blank to preview the report on all the payers.

    -  ``Claim Status``

      Select the claim status from the drop down list by clicking on the right arrow. By selecting any of the options a user can filter the report on a particular claim status. This filter is not mandatory, leave it blank to preview the report on all the claim statuses.

    -  ``Sorting``

      Select the way of sorting of records in the report from the list of available ways of sorting **(Renewal Date, Receipt Number, Enrolment Officer)**.

    -  ``Previous``

      Select the previous reports from the drop down list by clicking on the right arrow. By selecting any of the options a user can fetch a report which was produced before. `*Note: This filter is available only for Matching Funds Report.`*

    -  ``Date Selector Button``

      Clicking on the ``Date Selector Button`` will pop-up an easy to use, calendar selector (:ref:`image222`) by default the calendar will show the current month, or the month of the currently selected date, with the current day highlighted.

        -  At anytime during the use of the pop-up, the user can see the date of *today*.
        -  Clicking on *today* will close the pop-up and display the today’s date in the corresponding date entry box.
        -  Clicking on any day of the month will close the pop-up and display the date selected in the corresponding date entry box.
        -  Clicking on the arrow to the left displays the previous month.
        -  Clicking on the arrow on the right will displays the following month.
        -  Clicking on the month will display all the months for the year.
        -  Clicking on the year will display a year selector.

      .. _image222:
      .. |logo45| image:: /img/user_manual/image6.png
        :scale: 100%
        :align: middle
      .. |logo46| image:: /img/user_manual/image7.png
        :scale: 100%
        :align: middle
      .. |logo47| image:: /img/user_manual/image8.png
        :scale: 100%
        :align: middle

      +----------++----------++----------+
      | |logo45| || |logo46| || |logo47| |
      +----------++----------++----------+

        `Image 222 - Calendar Selector - Search Panel`

  B. Report Type Selector

  This panel contains a list of available report types. A user can select to create a desired report by clicking on the report type list item (:ref:`image223`) and narrow the report using the criteria being shown on the panel above, and then click the preview button to create the report. Available report types are:

    -  Primary Operational Indicators Report.
    -  Derived Operational Indicators Report.
    -  Contribution Collection Report.
    -  Product Sales Report.
    -  Contribution Distribution.
    -  User Activity Report.
    -  Enrolment Performance Indicators
    -  Status of Registers
    -  Insures without Photos.
    -  Matching Funds.
    -  Claim Overview.
    -  Payment Category Overview.
    -  Families and Insurees Overview.
    -  Pending Insurees.
    -  Percentage of Referrals.
    -  Capitation Payment

  .. _image223
  .. figure:: /img/user_manual/image192.png
    :align: center

    `Image 223 - Report Type Selector`

  C. Button Panel

    -  ``Preview button``

      By clicking on this button, the system will process the selected report type basic on the corresponding criteria submitted and re-direct current user to `Report Page <#reports>`__, for previewing the processed report. At any time the user clicks on the preview button, the current criteria will be saved in the session and can be reused later in the same session and for other report types where the same criteria are found.

    -  ``Cancel button``

      By clicking on this button, the current user will be re-directed to the `Home Page <#image-2.2-home-page>`__.

  D. Information Panel

  The Information Panel is used to display messages back to the user. Messages will occur if there was an error at any time during the processing of the reports.

Report Preview
""""""""""""""

The report viewer offers the facility to navigate through the report either by using the arrows or by typing in a page number at the top of the report. Another feature of the report viewer is to export the report in different formats. Currently system supports three formats; Word, Excel and PDF. Select the desired format from the list by clicking on the Export link. Use the ``Go Back to Selector`` link to go back to the previous selection page.

..

Below are the types of reports as they can be seen in the report page.

  **1. primary operational indicators - policies report**

  The report provides aggregate data relating to policies and insurees according to insurance products. The report can be run by users with the role Manager. The table below will provide an overview on primary indicators of the report.

  +-----------------+-----------------+-----------------+-----------------+
  |     **Code**    |   **Primary     |  **Dimension**  | **Description** |
  |                 |  indicators**   |                 |                 |
  |                 |                 |                 |                 |
  +=================+=================+=================+=================+
  |     P1          |     Number of   |     Time,       |     The number  |
  |                 |     policies    |     Insurance   |     of policies |
  |                 |                 |     product     |     of given    |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product on  |
  |                 |                 |                 |     the last    |
  |                 |                 |                 |     day of a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Status of  |
  |                 |                 |                 |     the policy  |
  |                 |                 |                 |     is Active,  |
  |                 |                 |                 |     the last    |
  |                 |                 |                 |     day of      |
  |                 |                 |                 |     period is   |
  |                 |                 |                 |     within      |
  |                 |                 |                 |     <Effective  |
  |                 |                 |                 |     date,       |
  |                 |                 |                 |     Expiry day> |
  |                 |                 |                 |     )           |
  +-----------------+-----------------+-----------------+-----------------+
  | P2              |     Number of   |     Time,       |     The number  |
  |                 |     new         |     Insurance   |     of new      |
  |                 |     policies    |     product     |     policies of |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     ( Enrolment |
  |                 |                 |                 |     date is     |
  |                 |                 |                 |     within the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period,     |
  |                 |                 |                 |     there is    |
  |                 |                 |                 |     ``no``      |
  |                 |                 |                 |     preceding   |
  |                 |                 |                 |     policy with |
  |                 |                 |                 |     the same    |
  |                 |                 |                 |     (or before  |
  |                 |                 |                 |     converted)  |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product for |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     policy)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P3              |     Number of   |     Time,       |     The number  |
  |                 |     suspended   |     Insurance   |     of policies |
  |                 |     policies    |     product     |     for given   |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product     |
  |                 |                 |                 |     that were   |
  |                 |                 |                 |     suspended   |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Status of  |
  |                 |                 |                 |     the policy  |
  |                 |                 |                 |     is          |
  |                 |                 |                 |     Suspended,  |
  |                 |                 |                 |     suspension  |
  |                 |                 |                 |     took place  |
  |                 |                 |                 |     within the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P4              |     Number of   |     Time,       |     The number  |
  |                 |     expired     |     Insurance   |     of policies |
  |                 |     policies    |     product     |     for given   |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product     |
  |                 |                 |                 |     that        |
  |                 |                 |                 |     expired     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Status of  |
  |                 |                 |                 |     the policy  |
  |                 |                 |                 |     is Expired, |
  |                 |                 |                 |     expiration  |
  |                 |                 |                 |     took place  |
  |                 |                 |                 |     within the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P5              |     Number of   |     Time,       |     The number  |
  |                 |     renewals    |     Insurance   |     of policies |
  |                 |                 |     product     |     that were   |
  |                 |                 |                 |     renewed for |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product (or |
  |                 |                 |                 |     a converted |
  |                 |                 |                 |     one) during |
  |                 |                 |                 |     a           |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     ( Enrolment |
  |                 |                 |                 |     date is     |
  |                 |                 |                 |     within the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period,     |
  |                 |                 |                 |     there is a  |
  |                 |                 |                 |     preceding   |
  |                 |                 |                 |     policy with |
  |                 |                 |                 |     the same    |
  |                 |                 |                 |     (or before  |
  |                 |                 |                 |     converted)  |
  |                 |                 |                 |     product for |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     family) )   |
  +-----------------+-----------------+-----------------+-----------------+
  | P6              |     Number of   |     Time,       |     The number  |
  |                 |     insurees    |     Insurance   |     of insurees |
  |                 |                 |     product     |     covered by  |
  |                 |                 |                 |     policies of |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product on  |
  |                 |                 |                 |     the last    |
  |                 |                 |                 |     day of a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (An insuree |
  |                 |                 |                 |     belongs to  |
  |                 |                 |                 |     a family    |
  |                 |                 |                 |     with an     |
  |                 |                 |                 |     active      |
  |                 |                 |                 |     coverage on |
  |                 |                 |                 |     the last    |
  |                 |                 |                 |     day of the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period-see  |
  |                 |                 |                 |     P1 )        |
  +-----------------+-----------------+-----------------+-----------------+
  | P7              |     Number of   |     Time,       |     The number  |
  |                 |     newly       |     Insurance   |     of insurees |
  |                 |     insured     |     product     |     covered by  |
  |                 |     insurees    |                 |     new         |
  |                 |                 |                 |     policies of |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (An insuree |
  |                 |                 |                 |     belongs to  |
  |                 |                 |                 |     a family    |
  |                 |                 |                 |     with newly  |
  |                 |                 |                 |     acquired    |
  |                 |                 |                 |     policy      |
  |                 |                 |                 |     during the  |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period-see  |
  |                 |                 |                 |     P2 )        |
  +-----------------+-----------------+-----------------+-----------------+
  | P8              |     Newly       |     Time,       |     Amount of   |
  |                 |     collected   |     Insurance   |     acquired    |
  |                 |     Contributio |     product     |     Contributio |
  |                 | ns              |                 | ns              |
  |                 |                 |                 |     (for        |
  |                 |                 |                 |     policies of |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product)    |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period (    |
  |                 |                 |                 |     Date of     |
  |                 |                 |                 |     payment of  |
  |                 |                 |                 |     a           |
  |                 |                 |                 |     Contributio |
  |                 |                 |                 | n               |
  |                 |                 |                 |     is within   |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P9              |     Available   |     Time,       |     Amount of   |
  |                 |     Contributio |     Insurance   |     Contributio |
  |                 | ns              |     product     | ns              |
  |                 |                 |                 |     that should |
  |                 |                 |                 |     be          |
  |                 |                 |                 |     allocated   |
  |                 |                 |                 |     for         |
  |                 |                 |                 |     policies of |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product for |
  |                 |                 |                 |     a           |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |     provided a  |
  |                 |                 |                 |     uniform     |
  |                 |                 |                 |     distributio |
  |                 |                 |                 | n               |
  |                 |                 |                 |     throughout  |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     period      |
  |                 |                 |                 |     takes       |
  |                 |                 |                 |     place.      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (If the     |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |     overlaps    |
  |                 |                 |                 |     with        |
  |                 |                 |                 |     <Effective  |
  |                 |                 |                 |     date,       |
  |                 |                 |                 |     Expiry day> |
  |                 |                 |                 |     of a policy |
  |                 |                 |                 |     then a      |
  |                 |                 |                 |     proportiona |
  |                 |                 |                 | l               |
  |                 |                 |                 |     part of     |
  |                 |                 |                 |     correspondi |
  |                 |                 |                 | ng              |
  |                 |                 |                 |     Contributio |
  |                 |                 |                 | ns              |
  |                 |                 |                 |     relating to |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period is   |
  |                 |                 |                 |     included in |
  |                 |                 |                 |     available   |
  |                 |                 |                 |     Contributio |
  |                 |                 |                 | ns)             |
  +-----------------+-----------------+-----------------+-----------------+

  Below is an example of the report:

  .. _image224
  .. figure:: /img/user_manual/image193.png
    :align: center

    `Image 224 - Preview – Primary Operational Indicators - Policies Report`

  **2. primary operational indicators - claims report**

  The report provides aggregate data relating to policies and insurees according to insurance products. The report can be run by users with the role Manager. The table below will provide an overview on primary indicators of the report.

  +-----------------+-----------------+-----------------+-----------------+
  |     ``Code``    |     ``Primary   |     ``Dimension |     ``Descripti |
  |                 |     indicators* | ``              | on``            |
  |                 | *               |                 |                 |
  +=================+=================+=================+=================+
  | P10             |     Number of   |     Time,       |     The number  |
  |                 |     claims      |     Health      |     of claims   |
  |                 |                 |     facility,   |     for given   |
  |                 |                 |     Insurance   |     insurance   |
  |                 |                 |     product     |     product     |
  |                 |                 |                 |     that        |
  |                 |                 |                 |     emerged     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Start date |
  |                 |                 |                 |     of a claim  |
  |                 |                 |                 |     is within   |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P11             |     Amount      |     Time,       |     Amount      |
  |                 |     remunerated |     Health      |     remunerated |
  |                 |                 |     facility,   |     for claims  |
  |                 |                 |     Insurance   |     for given   |
  |                 |                 |     product     |     insurance   |
  |                 |                 |                 |     product     |
  |                 |                 |                 |     that        |
  |                 |                 |                 |     emerged     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Start date |
  |                 |                 |                 |     of a claim  |
  |                 |                 |                 |     is within   |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period)     |
  +-----------------+-----------------+-----------------+-----------------+
  | P12             |     Number of   |     Time,       |     The number  |
  |                 |     rejected    |     Health      |     of claims   |
  |                 |     claims      |     facility,   |     for given   |
  |                 |                 |     Insurance   |     insurance   |
  |                 |                 |     product     |     product     |
  |                 |                 |                 |     that        |
  |                 |                 |                 |     emerged     |
  |                 |                 |                 |     during a    |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period and  |
  |                 |                 |                 |     were        |
  |                 |                 |                 |     rejected    |
  |                 |                 |                 |                 |
  |                 |                 |                 |     (Start date |
  |                 |                 |                 |     of a claim  |
  |                 |                 |                 |     is within   |
  |                 |                 |                 |     the         |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period and  |
  |                 |                 |                 |     the Status  |
  |                 |                 |                 |     approval of |
  |                 |                 |                 |     the claim   |
  |                 |                 |                 |     is Rejected |
  |                 |                 |                 |     )           |
  +-----------------+-----------------+-----------------+-----------------+

  Below is an example of the report:

  .. _image225
  .. figure:: /img/user_manual/image194.png
    :align: center

    `Image 225 . Preview – Primary Operational Indicators - Claims Report`

  **3. derived operational indicators report**

  The report provides operational indicators derived from primary operational indicators. The report can be run by users with the role Manager. The table below will provide an overview on the actual derived indicators provided by the report.

  +-----------------+-----------------+-----------------+-----------------+
  |     ``Code``    |     ``Derived   |     ``Dimension |     ``Descripti |
  |                 |     indicators* | ``              | on``            |
  |                 | *               |                 |                 |
  +=================+=================+=================+=================+
  |     D1          | Incurred claims |     Time,       |     It is the   |
  |                 | ratio           |     Insurance   |     ratio       |
  |                 |                 |     product     |     P11/P9      |
  +-----------------+-----------------+-----------------+-----------------+
  | D2              |     Renewal     |     Time,       |     It is the   |
  |                 |     ratio       |     Insurance   |     ratio P5/P4 |
  |                 |                 |     product     |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | D3              |     Growth      |     Time,       |     It is the   |
  |                 |     ratio       |     Insurance   |     ratio       |
  |                 |                 |     product     |     P2/P1-for   |
  |                 |                 |                 |     immediately |
  |                 |                 |                 |     preceding   |
  |                 |                 |                 |     period      |
  +-----------------+-----------------+-----------------+-----------------+
  | D4              |     Promptness  |     Time,       |     It is the   |
  |                 |     of claims   |     Insurance   |     average     |
  |                 |     settlement  |     product     |     (date of    |
  |                 |                 |                 |     sending to  |
  |                 |                 |                 |     payment-Dat |
  |                 |                 |                 | e               |
  |                 |                 |                 |     of          |
  |                 |                 |                 |     submission  |
  |                 |                 |                 |     of the      |
  |                 |                 |                 |     claim) for  |
  |                 |                 |                 |     all claims  |
  |                 |                 |                 |     relating to |
  |                 |                 |                 |     given       |
  |                 |                 |                 |     insurance   |
  |                 |                 |                 |     product and |
  |                 |                 |                 |     emerging in |
  |                 |                 |                 |     a           |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  |                 |                 |                 |                 |
  |                 |                 |                 |     Date of     |
  |                 |                 |                 |     sending of  |
  |                 |                 |                 |     payment is  |
  |                 |                 |                 |     not in the  |
  |                 |                 |                 |     structure   |
  |                 |                 |                 |     of Claim,   |
  |                 |                 |                 |     it has to   |
  |                 |                 |                 |     be          |
  |                 |                 |                 |     retrieved   |
  |                 |                 |                 |     from a      |
  |                 |                 |                 |     journal-can |
  |                 |                 |                 |     be?)        |
  +-----------------+-----------------+-----------------+-----------------+
  | D5              |     Claims      |     Time,       |     It is the   |
  |                 |     settlement  |     Health      |     ratio       |
  |                 |     ratio       |     facility,   |     (P10-P12)/P |
  |                 |                 |     Insurance   | 10              |
  |                 |                 |     product     |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | D6              |     Number of   |     Time,       |     It is the   |
  |                 |     claims per  |     Insurance   |     ratio       |
  |                 |     insuree     |     product     |     P10/P6      |
  +-----------------+-----------------+-----------------+-----------------+
  | D7              |     Average     |     Time,       |     It is the   |
  |                 |     cost per    |     Health      |     ratio       |
  |                 |     claim       |     facility,   |     P11/P10     |
  |                 |                 |     Insurance   |                 |
  |                 |                 |     product     |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | D8              |     Satisfactio |     Time,       |     The average |
  |                 | n               |     District,   |     mark from   |
  |                 |     level       |     Health      |     feedbacks   |
  |                 |                 |     facility    |     received in |
  |                 |                 |                 |     a           |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  +-----------------+-----------------+-----------------+-----------------+
  | D9              |     Feedback    |     Time,       |     The ratio   |
  |                 |     response    |     District,   |     of number   |
  |                 |     ratio       |     Health      |     of          |
  |                 |                 |     facility    |     feedbacks   |
  |                 |                 |                 |     received    |
  |                 |                 |                 |     (up to time |
  |                 |                 |                 |     of creation |
  |                 |                 |                 |     of the      |
  |                 |                 |                 |     report) and |
  |                 |                 |                 |     number of   |
  |                 |                 |                 |     feedbacks   |
  |                 |                 |                 |     asked for   |
  |                 |                 |                 |     in a        |
  |                 |                 |                 |     respective  |
  |                 |                 |                 |     period      |
  +-----------------+-----------------+-----------------+-----------------+

  Below is an example of the report:

  .. _image226
  .. figure:: /img/user_manual/image195.png
    :align: center

    `Image 226 - Preview – Derived Operational Indicators Report`

  **4. Contribution collection report**

  The report lists all actual payments of contributions according to insurance products in the defined period. The report can be used as input to an accounting system. The report can be run by users with the role Accountant. Payments are assigned to the specified period according to the actual date of payment.

  ..

  Below is an example of the report:

  .. _image227
  .. figure:: /img/user_manual/image196.png
    :align: center

    `Image 227 - Preview – Contribution Collection Report`

  **5. product sales report**

  The report provides overview of selling of policies according to insurance products in terms of calculated contributions (not necessarily actually paid). The report can be run by users with the role Accountant. Policies are assigned to the specified period according to their effective days.

  ..

  Below is an example of the report:

  .. _image228
  .. figure:: /img/user_manual/image197.png
    :align: center

    `Image 228 - Preview – Product Sales Report`

  **6. Contribution distribution report**

  The report provides proportional amount of actually paid contributions allocated by IMIS to specific months according to insurance products. The report can be run by users with the role Accountant. This report shows the information about the **Total collection**, **Allocated amount** and **Not allocated** amount for contributions in the specified period.

  ..

  **Allocated** amount is the proportionally calculated amounts of contributions paid covering the month. **Not Allocated** amount is the amount collected for contributions that have a start date in the future (after the month in question).

  ..

  Below is an example of the report:

  .. _image229
  .. figure:: /img/user_manual/image198.png
    :align: center

    `Image 229 - Preview – Contribution Distribution Report`

  **7. user activity report**

  The report shows activities of users according to types of activities and types of entities to which the activities relate. The report can be run by users with the role IMIS Administrator. Below is an example of the report:

  .. _image230
  .. figure:: /img/user_manual/image199.png
    :align: center

    `Image 230 - Preview – User Activity Report`

  **8. enrolment performance indicator report**

  The report provides overview of activity of enrolment officers. The report can be run by users with the role Manager. Below is an example of the report:

  .. _image231
  .. figure:: /img/user_manual/image200.png
    :align: center

    `Image 231 - Preview – Enrolment Performance Indicator Report`

  **9. status of registers report**

  The report provides an overview of the number of items in registers according to districts. The report can be run by users with the role Scheme Administrator. Below is an example of the report:

  .. _image232
  .. figure:: /img/user_manual/image201.png
    :align: center

    `Image 232 - Preview – Status of Registers Report`

  **10. insurees without photos**

  The report lists all insurees according to enrolment officers that have not assigned a photo. The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image233
  .. figure:: /img/user_manual/image202.png
    :align: center

    `Image 233 - Preview – Insurees without photos`

  **11. matching funds**

  The report lists all families/groups according to insurance products and (institutional) payers that paid contributions in the specified period. This report is useful for claiming of subsidies for running of health insurance schemes. The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image234
  .. figure:: /img/user_manual/image203.png
    :align: center

    `Image 234 - Preview –Matching Funds`

  **12. claim overview**

  The report provides detailed data about results of processing of claims in IMIS according to insurance products and health facilities. The report can be used as a tool for communication between a health insurance scheme and its contractual health facilities. The report can be run by users with the role Accountant. Claims are assigned to the specified period according to date of provision of health care (in case of in-patient care according to the date of discharge). Below is an example of the report:

  .. _image235
  .. figure:: /img/user_manual/image204.png
    :align: center

    `Image 235 Preview – Claim Overview`

  **13. payment category overview**

  The report provides split of total contributions according to their categories. The report can be run by users with the role Accountant. Contributions are assigned to the specified period according to actual payment date. Below is an example of the report:

  .. _image236
  .. figure:: /img/user_manual/image205.png
    :align: center

    `Image 236 - Preview – Payment Category Overview`

  **14. Families and Insurees Overview report**

  The report provides an overview of enrolled families/groups and their members in specified location within the specified period. The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image237
  .. figure:: /img/user_manual/image206.png
    :align: center

    `Image 237 - Preview – Families and Insurees Overview Report`

  **15. Percentage of Referrals report**

  The report lists all primary health care facilities (the category is Dispensary and Health Centre) in the selected district and for each such health facilities provides the following indicators:

    a) The number of visits (claims) of the primary health care facility in the selected period.
    b) The number of out-patient visits that have Visit Type equal to Referral in all other health facilities (irrespective of the district) for insurees with the First Service Point in the respective primary health care facility.
    c) The number of in-patient stays that have Visit Type equal to Referral in all health facilities-hospitals (irrespective of the district) for insurees with the First Service Point in the respective primary health care facility.

  The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image238
  .. figure:: /img/user_manual/image207.png
    :align: center

    `Image 238 - Preview – Percentage of Referrals Overview Report`

  **16. Pending Insurees report**

  The report lists all insurees whose photos have been sent to IMIS but who has no record in IMIS yet. The report can be run by users with the role Accountant.  Below is an example of the report:

  .. _image239
  .. figure:: /img/user_manual/image208.png
    :align: center

    `Image 239 - Preview – Pending Insurees Report`

  **17. Renewals report**

  The report lists all renewed policies in given period for given insurance product and optionally for given enrolment officer. The families that have at least one payment of contributions in given period of time are included in the report. The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image240
  .. figure:: /img/user_manual/image209.png
    :align: center

    `Image 240 - Preview – Renewals Report`

  **18. Capitation Payment Report**

  The report lists capitation payments for all health facilities specified in the `capitation formula <#capitation-payment>`__ for specified month and for given insurance product. The report can be run by users with the role Accountant. Below is an example of the report:

  .. _image241
  .. figure:: /img/user_manual/image210.png
    :align: center

    `Image 241 - Preview –Capitation Payment Report`

Utilities
^^^^^^^^^

Access to the ``Utilities`` is restricted to the users with the role of IMIS Administrator.

..

The ``Utilities`` is the place for database administration. By having access to this page, it is possible to backup and restore the IMIS operational database and also to execute SQL Scripts (patches provided for maintenance or update of the database). At the top of the page, the current “Backend” version is displayed for reference.

Navigation
""""""""""

All functionality for use with the administration of utilities can be found under the main menu ``Tools``, sub menu ``Utilities``

.. _image242
.. figure:: /img/user_manual/image211.png
  :align: center

  `Image 242 - Navigation Utilities`

Clicking on the sub menu ``Utilities`` re-directs the current user to the `Utilities Page. <#image-6.75-utilities-page>`__

.. _image243
.. figure:: /img/user_manual/image212.png
  :align: center

  `Image 243 - Utilities Page`

Backup
""""""

Backup utility can be found in the top panel of the `Utilities Page <#Utilities>`_. By default the path of the backup folder will be populated from the default table. User can change the path according to the requirement. Next to the textbox user can see one heck box called ``Save Path``. If user wants to update the backup folder in default table then this check box should be in checked state. Otherwise system will take the backup on the folder assigned by the user but it will not be updated in database. So next time when user comes on the `Utilities Page <#Utilities>`_, the textbox will be populated with the original path. After the path has been entered user can just click on the ``Backup button`` to start the process and a progress bar will be appeared on the screen. Users are requested to be patient while the system performs the task.

.. _image244
.. figure:: /img/user_manual/image213.png
  :align: center

  `Image 244 - Backup is in progress`

Restore
"""""""

Restore utility can be found in the second panel of the `Utilities Page <#Utilities>`_. User will have to put the path of the backup file to be restored. After the path has been entered user can just click on the ``Restore`` button to start the process and a progress bar will be appeared on the screen. Users are requested to be patient while the system performs the task.

.. _image245
.. figure:: /img/user_manual/image213.png
  :align: center

  `Image 245 - Backup is in progress`

Execute script
""""""""""""""

Execute script can be found in the third panel of the `Utilities Page <#Utilities>`_. User will have to choose the script by clicking on the browse button. User will have to select the file only with the ".isf" extension. After the file has been chosen, user can just click on the ``Execute`` button to run the script. Users are requested to be patient while the system is executing the script. After the script is executed successfully, backed version will be updated to the latest version. If user will try to run the lower or the equal version's script then system will prompt the user with the appropriate message.

Funding
^^^^^^^

Access to the ``Funding`` is restricted to the users with the role of Accountant.

..

The ``Funding`` is the place where funding from external authorities (payers) can be for entered. IMIS creates internally one fictive family/group (the insurance number of the head of the fictive family/group is 999999999, the name is *Funding* and the other name is *Funding* as well) for the district for which a funding is done. Each entering of a fund results in creation of a fictive policy for the corresponding fictive family/group with paid contribution in the amount of the funding. The fictive policy is active since the date of payment of the corresponding fund. These fictive policies are overpaid as these funds are usually much higher than the contribution rate for a single family/member of the group but it doesn’t matter. External funding corresponds to payment of contributions for many families/members of the group in some period. IMIS can regard funds as standard contributions and its standard functionality can be used for handling of funds. One distinctive feature of payment of funds by means of the fictive policies is that the payments of funds don’t appear in the reports on matching funds generated for funding authorities. So, there is no danger that offices of the scheme administration would acquire new funds based on funding already acquired.

.. _navigation-25:

Navigation
""""""""""

The functionality for entering of funds can be found under the main menu ``Tools``, sub menu ``Funding``

.. _image246
.. figure:: /img/user_manual/image214.png
  :align: center

  `Image 246 - Navigation Funding`

Clicking on the sub menu ``Funding`` re-directs the current user to the `Funding Page. <#image-6.79-funding-page>`__

Funding Page
""""""""""""

  **1. Data Entry**

  .. _image247
  .. figure:: /img/user_manual/image215.png
    :align: center

    `Image 247 - Funding Page`

..

    -  ``Region``

      Select the region from the list of regions for which the funding is designated by clicking on the arrow on the right of the selector. `*Note: The list will only be filled with the regions assigned to the current logged in user.`*

    -  ``District``

      Select the district from the list of districts for which the funding is designated. by clicking on the arrow on the right of the selector. `*Note: The list will only be filled with the districts belonging to the selected region and assigned to the current logged in user.`*

    -  ``Product``

      Select an insurance product from the list of insurance products purchased in the selected district (including national insurance products) for which the funding is designated.

    -  ``Payer``

      Select from the list of institutional payers the funding authority/agency.

    -  ``Payment Date``

      Enter the date of receiving of the funding.

    -  ``Contribution Paid``

      Enter the amount of the funding.

    -  ``Receipt Number``

      Enter an identification of the document accompanying the funding.

  **2. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. A message confirming that the new password has been saved will appear. The user will be re-directed back to the `Home Page <#image-2.2-home-page>`__.

  **3. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right side of the corresponding field). The user will be re-directed to the `Home Page <#image-2.2-home-page>`__.

  **4. Cancel**

  By clicking on the Cancel button, the user will be re-directed to the `Home Page <#image-2.2-home-page>`__.

Changing of user’s password
---------------------------

Any user can change his/her password by adjustment of his/her profile.

Navigation
^^^^^^^^^^

Functionality for changing of a password can be in the menu ``My Profile``, sub menu ``Change Password``

.. _image248
.. figure:: /img/user_manual/image216.png
  :align: center

  `Image 248 - Navigation Change Password`

Clicking on the sub menu ``Change Password`` re-directs the current user to the `Change Password Page. <#image-7.2-change-password-page>`__

Change Password Page
^^^^^^^^^^^^^^^^^^^^

  **5. Data Entry**

  .. _image249
  .. figure:: /img/user_manual/image217.png
    :align: center

    `Image 249 - Change Password Page`

..

    -  ``Current Password``

      Enter the password of the current user.

    -  ``New Password``

      Enter a new password of the current user. The password should have at least 8 alphanumeric characters with at least one digit.

    -  ``Confirm Password``

      Repeat the new password of the current user.

  **6. Saving**

  Once all mandatory data is entered, clicking on the ``Save`` button will save the record. The user will be re-directed back to the `Home Page <#image-2.2-home-page>`__. A message confirming that the new password has been saved will appear at the bottom.

  **7. Mandatory data**

  If mandatory data is not entered at the time the user clicks the ``Save`` button, a message will appear in the Information Panel, and the data field will take the focus (by an asterisk on the right side of the corresponding field).

  **8. Cancel**

  By clicking on the Cancel button, the user will be re-directed to the `Home Page <#image-2.2-home-page>`__

IMIS OFFLINE
------------

Introduction
^^^^^^^^^^^^

IMIS system can be used in offline mode, which makes it possible for usage by health facilities (HF) and scheme administration offices with low/no internet connectivity.

OFFLINE FACILITIES
^^^^^^^^^^^^^^^^^^

Facilities available while offline and online in IMIS, are similar with some few differences. The following are the feature wise differences found while using IMIS in offline mode.

  A. ``LOGIN``

  If a user who is logging in is having user role HF Administrator or offline Scheme Administrator and if Heath Facility ID/Scheme Office ID is not set yet, just after clicking login button on the login screen/page, the user will be prompted to enter Health Facility/Scheme Office ID (:ref:`image250`), (:ref:`image251`), only once for that very first time of logging in.

  .. _image250
  .. figure:: /img/user_manual/image218.png
    :align: center

    `Image 250 - Enter HF ID - HF Administrator Login, IMIS offline`

  .. _image251
  .. figure:: /img/user_manual/image219.png
    :align: center

    `Image 251 - Enter Scheme Office ID - offline Scheme Administrator Login, IMIS offline`

  B. ``INFORMATION BAR``

  Throughout the application, an information bar at the bottom of each page will have a different background colour to that of online IMIS and on the its right end, there will be shown heath facility code and health facility name / Scheme Office ID submitted (:ref:`image252`), (:ref:`image253`).

  .. _image252
  .. figure:: /img/user_manual/image220.png
    :align: center

    `Image 252 - Information Bar – Scheme Office, IMIS offline`

  .. _image253
  .. figure:: /img/user_manual/image221.png
    :align: center

    `Image 253 - Information Bar - Health Facility, IMIS offline`

  C. ``MENUS ACCESS``

  For all users with roles other than HF Administrator and Offline Scheme Administrator , will have the menus available to them as per normal roles' rights in online IMIS version. Menu access in the offline version is different in following scenarios:

    -  User with roles HF Administrator and Offline Scheme Administrator can access only ``Users``, ``IMIS Extracts`` and ``Utilities`` menus, while all other users with different roles can access menus just as they would do in the online IMIS version.

      -  ``Extracts``
        Extracts Menu leads an offline user to Extracts control panel. Using this panel, an offline user with rights to this panel can import data from online IMIS to the local offline IMIS, and can also download claims and enrolments prior to upload them to the online IMIS. This panel is divided into five sections (:ref:`image254`), (:ref:`image255`) If an offline user is HF Administrator, section C will contain facility to ``Download Claims``. If an offline user is Offline Scheme Administrator, section C will contain facility to ``Download Enrolments``

        .. _image254
        .. figure:: /img/user_manual/image222.png
          :align: center

          `Image 254 - Extracts Control Page, HF Administrator, IMIS offline`

        .. _image255
        .. figure:: /img/user_manual/image223.png
          :align: center

          `Image 255 - Extracts Control Page, Offline Scheme Administrator, IMIS offline`

      -  ``section a - import extract``

        This section has a facility to enable synchronization of online IMIS data with that offline IMIS data. When online data in a zipped file is obtained (downloaded extraction) from online IMIS to user local computer, user will use this section to put that data into offline IMIS.

        ..

        User has to select a file from a local computer by clicking the 'select file' button on the left side of the section, and in the popup window which appears (:ref:`image256`) user can navigate to the required file and select the file.

        .. _image256
        .. figure:: /img/user_manual/image224.png
          :align: center

          `Image 256 - Select File Popup Window, Import Extracts, IMIS offline`

        After clicking the upload button on the very end of right hand side in this section, data in the file will be imported to the offline IMIS and confirmation will be given as popup messages (:ref:`image257`), (:ref:`image258`).

        .. _image257
        .. figure:: /img/user_manual/image225.png
          :align: center

          `Image 257 - Popup Window, Import Extracts, HF Administrator, IMIS offline`

        .. _image258
        .. figure:: /img/user_manual/image226.png
          :align: center

          `Image 258 - Popup Window, Import Extracts, Offline Scheme Administrator, IMIS offline`

        User cannot import an extract whose sequence number is same as last one imported; if done so, a popup message (:ref:`image259`) will be shown.

        .. _image259
        .. figure:: /img/user_manual/image227.png
          :align: center

          `Image 259 - Popup Window, Wrong sequence of an extract file, IMIS offline`

      -  ``section b - import photos``

        Just as the section name implies, this is a section with facility to enable a user synchronize insurees’ photos in online IMIS, with insurees’ photos in offline IMIS. When online insurees’ photos in a zipped file is obtained from online IMIS to user local computer, user will use this section to put those photos into offline IMIS.

        ..

        User has to select a file from a local computer by clicking the 'select file' button on the left side of the section, and in the popup window which appears (:ref:`image260`), user can navigate to the required file and select the file.

        .. _image260
        .. figure:: /img/user_manual/image228.png
          :align: center

          `Image 260 - Select File Popup Window, Import Photos, IMIS offline`

        After clicking the upload button on the very end of right hand side in this section, data in the file will be imported to the offline IMIS and confirmation will be given as popup messages (:ref:`image261`).

        .. _image261
        .. figure:: /img/user_manual/image229.png
          :align: center

          `Image 261 - Popup Window, Import Photos, IMIS offline`

        If importation of photo is not done due to some reason, the above popup message will not be shown, instead system will issue proper popup message to notify a user what went wrong and what is to be done.

      -  ``section c - download claim xmls``

        This section has facility to enable offline HF Administrator download to a zipped file all offline claims. By clicking the download button on the right hand side, the user initiate download process and all offline claims will be downloaded to a default downloads folder in user's local computer or a prompt of 'where to save file' will be displayed by browser'. User can navigate through folder in his/her local computer to find the file downloaded. If no new claims found, a message will be displayed.

      -  ``download enrolment xmls``

        This section has facility to enable Offline Scheme Administrator download to a zipped file all offline enrollments of families, insurees, policies and contributions. By clicking the download button on the right hand side, the user initiate download process. If no enrolment found, a popup message box (:ref:`image262`) will appear, notifying the user. Otherwise enrollments will be downloaded in a zipped file and a confirmation popup message (:ref:`image263`) will appear

        .. _image262
        .. figure:: /img/user_manual/image230.png
          :align: center

          `Image 262 - Popup Window, Download Enrolments, IMIS offline`


          .. _image263
          .. figure:: /img/user_manual/image231.png
            :align: center

            `Image 263 - Popup Window, Download Enrolments, IMIS offline`

      -  ``section d - buttons``

        This section has a cancel button, which when clicked will take the current user to the Home page.

      -  ``section e - information bar``

        Information bar at the bottom will show different notification messages in blue color depending on the actions of the user. Such actions and messages may be:

        a) No Previous Extract Found
          This message is seen at the first time when using the system and no any extract has been imported into the offline IMIS

          .. _image264
          .. figure:: /img/user_manual/image232.png
            :align: center

            `Image 264 - IMIS Extracts, Information Bar, IMIS offline`

        b) Last Extract Sequence: < Sequence Number >

          This message is seen, after a single / series of extract importation have been made to the offline IMIS and that much times will be shown as a sequence number at the end of the message. This enables proper tracking of right extracts to import and use.

          .. _image265
          .. figure:: /img/user_manual/image233.png
            :align: center

            `Image 265 - IMIS Extracts, Information Bar, IMIS offline`

        c) No claims Found

          When HF offline IMIS user is downloading offline claims and no new offline claims is found, this message is displayed.

          .. _image266
          .. figure:: /img/user_manual/image234.png
            :align: center

            `Image 266 - IMIS Extracts, Information Bar, IMIS offline`

-  USERS

   Users with role HF Administrator, can create only users with roles:
   ``Receptionist, Claim Administrator`` and ``HF Administrator``
   `(Image
   8.18) <#image-8.18-users-page---hf-administrator-imis-offline>`__.
   User with role 'offline NSHIP Administrator', can create only user
   with role\ ``: Clerk`` `(Image
   8.19) <#image-8.19-users-page---offline-scheme-administrator-imis-offline>`__

   |image280|

 Image 8.18 (Users Page - HF Administrator, IMIS offline)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|image281|

 Image 8.19 (Users Page - Offline Scheme Administrator, IMIS offline)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

D. data access

-  Search / Find

   In all pages in Insurees and Policies menus with search / find
   facility, there will be an extra search criteria `(Image
   8.20) <#image-8.20-search-criteria---offline-only-data-imis-offline>`__
   to enable search for offline data only. This feature is available if
   a user is in Offline IMIS.

   |image282|

 Image 8.20 (Search Criteria - offline only data, IMIS offline)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  Create / Edit

   Only families, insurees, policies and contributions created/edited
   while offline, will be available for further manipulation. An online
   data is available for viewing purposes.

   For an offline user with a right to open Insurees and Policies menus,
   he/she can access all data but can manipulate only that data which
   was created offline. The rest of the data will be available in
   read-only mode

Analytic and reporting component (AR-IMIS)
==========================================

    The Analytic and Reporting component of the Insurance Management
    Information System (AR-IMIS) provides managerial data for management
    of health insurance schemes supported by IMIS, allows easy and
    speedy analysis of these data with the objective to reveal causes of
    different phenomena encountered in supported health insurance
    schemes. Provided data allow also monitoring of developments within
    supported health insurance schemes and identification of potential
    errors in operational data.

Concept of AR-IMIS
------------------

    The concept of AR-IMIS is based on populating of the Data Warehouse
    with aggregate data from the operational database of IMIS. This
    populating is done automatically and regularly (usually once a week)
    from the operational database by Extract, Transformation and Loading
    process (ETL). Within this process data from the operational
    database are aggregated and stored in the Data Warehouse in
    conformance with multidimensional data model (`Image
    9.1 <#image-9.1-concept-of-ar-imis>`__)

    |image283|

Image 9.1 Concept of AR-IMIS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    This model is suitable for analysis of data. Questions like “What is
    the number of newly covered insurees by an insurance product at
    during a calendar period and who were of an age, a gender, lived in
    a location and were cared for by a enrolment officer? Data in the
    multidimensional Data Warehouse are presented by a suitable
    front-end tool. Currently AR-IMIS uses MS Excel as the front-end
    presentation tool. An Excel file is remotely connected to the Data
    Warehouse and data are stored in the Excel file in the form of so
    called pivot tables. The multidimensional model is based on the
    notion of facts and dimensions. The facts (indicators) are what we
    are interested in. For example, a fact may number of insured
    persons, number of active policies, number of submitted claims etc.
    Facts can be looked at from different angles-for example from the
    point of view of age and gender of insured persons, from the point
    of view of time period etc. These angles (points of view) are
    captured by the notion of dimensions that are used for qualification
    of facts `Image 9.2 <#image-9.2-facts-and-dimensions>`__

    |image284|

Image 9.2 Facts and dimensions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    A dimension is composed from points that represent specific values
    in the dimension for which we want to look at facts-for example
    *November* 2015 may be one point in the Time dimension. Points of a
    dimension may be organized in hierarchies. Higher levels of
    hierarchies represent more aggregate views. Going to the lower
    levels by so called *drill down* operation we can analyze facts in
    more detail-for example we may drill down from calendar years to
    quarters of corresponding calendar years and further to months. We
    can go in an opposite direction and look at facts from more
    aggregate points of view (*drill up*).For example from looking at
    the amount of collected contributions in calendar months we can look
    at the same indicator according to quarters of a year or according
    to calendar years.

    Facts with related meaning and the identical set of qualifying
    dimension are represented in the multidimensional model of the Data
    Warehouse as so called cubes. We can do other operations on cubes as
    for example *slicing* when we select one or several points in one
    dimension and look at the rest of cube or dicing when we select on
    or several points in two or more dimensions. All such operations
    allow analysis of data in the Data Warehouse in an easy and
    comprehensive way.

Dimensions
----------

    Dimensions represent our point of view on facts. Each dimension has
    several values (points). The points are used for qualification of
    our view on the facts. AR-IMIS provides values of facts
    corresponding to specified points across one or more dimensions. The
    points may be organized in hierarchies. Lower levels of a hierarchy
    allow looking at a fact according to more specific points. For
    example, the most important *Time* dimension has at the lowest level
    calendar months. The calendar months are grouped into quarters and
    quarters into calendar years. So, we can get a value of a fact
    corresponding to a specific month. Going one level up in the
    dimension *Time*, we can get can get a value of the fact
    corresponding to a specific quarter and going even up we can get a
    value of the fact corresponding to a specific calendar year. If we
    don’t specify any point in a dimension, it means we are interested
    in a value of a fact for all points together in the given dimension.

    AR-IMIS defines several dimensions. Their meaning is dependent on
    the context of a fact for which they are used. For example, for the
    fact *Number of submitted claims* the *Time* dimension means in
    AR-IMIS a period in which claimed health care was provided. It could
    have also other interpretations, for example, it may be a period in
    which claims were submitted. Exact interpretation of each dimension
    is indicated with description of each fact provided below.

    The points of a dimension are either fixed, e. g. the points *Sex*
    are *Male/Female/Undefined* for the dimension, or are obtained from
    registers in the operational part of IMIS. For example, the points
    for the dimension *Services* are obtained from the current status of
    the register of services in IMIS.

    The following table shows dimensions used across AR-IMIS. For each
    dimension its name, names of attributes used for referencing of
    their points, source for their points, and their meaning.

+-----------------+-----------------+-----------------+-----------------+
|     Name        | Names of        | Source of data  | Points          |
|                 | hierarchy/attri |                 |                 |
|                 | butes           |                 |                 |
+=================+=================+=================+=================+
| ``Time``        | Time Hierarchy  | generated by    | Hierarchy:      |
|                 |                 | IMIS            |                 |
|                 | ``Other         |                 | Years->Quarters |
|                 | fields``:       |                 | ->Months        |
|                 |                 |                 |                 |
|                 | Month Name      |                 |                 |
|                 |                 |                 |                 |
|                 | Quarter Name    |                 |                 |
|                 |                 |                 |                 |
|                 | Year Time       |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Age``         | Age Range       | generated by    | below1,1-4,5-9… |
|                 |                 | IMIS            | ,               |
|                 |                 |                 | 80+,Unkown      |
+-----------------+-----------------+-----------------+-----------------+
| ``Gender``      | Gender Name     | generated by    | Male, Female,   |
|                 |                 | IMIS            | Unknown         |
+-----------------+-----------------+-----------------+-----------------+
| ``Regions``     | Region          | `register of    | Hierarchy:      |
|                 | Hierarchy       | locations <#loc |                 |
|                 |                 | ations-administ | Regions->Distri |
|                 | ``Other         | ration>`__      | cts->Wards->Vil |
|                 | fields``:       |                 | lages           |
|                 |                 |                 |                 |
|                 | Region          |                 |                 |
|                 |                 |                 |                 |
|                 | District        |                 |                 |
|                 |                 |                 |                 |
|                 | Ward            |                 |                 |
|                 |                 |                 |                 |
|                 | Village         |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Products``    | Product         | `register of    | Hierarchy:      |
|                 | Hierarchy       | insurance       |                 |
|                 |                 | products <#insu | Regions->Distri |
|                 | ``Other         | rance-products- | cts->Products   |
|                 | fields``:       | administration> |                 |
|                 |                 | `__             |                 |
|                 | Region          |                 |                 |
|                 |                 |                 |                 |
|                 | District        |                 |                 |
|                 |                 |                 |                 |
|                 | Product Name    |                 |                 |
|                 |                 |                 |                 |
|                 | Product Code    |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Payers``      | Payer Name      | `register of    | Families,       |
|                 |                 | payers <#payers | Payers (the     |
|                 |                 | -administration | list of)        |
|                 |                 | >`__            |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Officers``    | Officer         | `register of    | Hierarchy:      |
|                 | Hierarchy       | enrolment       |                 |
|                 |                 | officers <#enro | Regions->Distri |
|                 | ``Other         | lment-officers- | cts->Enrolment  |
|                 | fields``:       | administration> | Officers        |
|                 |                 | `__             |                 |
|                 | Region          |                 |                 |
|                 |                 |                 |                 |
|                 | District        |                 |                 |
|                 |                 |                 |                 |
|                 | Last Name       |                 |                 |
|                 |                 |                 |                 |
|                 | Other Names     |                 |                 |
|                 |                 |                 |                 |
|                 | Assistant Code  |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Services``    | Service         | `register of    | Hierarchy:      |
|                 | Hierarchy       | medical         |                 |
|                 |                 | services <#medi | (Curative,      |
|                 | ``Other         | cal-services-ad | Preventive)->Se |
|                 | fields``:       | ministration>`_ | rvices          |
|                 |                 | _               |                 |
|                 | Service Code    |                 |                 |
|                 |                 |                 |                 |
|                 | Service Name    |                 |                 |
|                 |                 |                 |                 |
|                 | Service         |                 |                 |
|                 | Category        |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Items``       | Item Hierarchy  | `register of    | Hierarchy:      |
|                 |                 | medical         |                 |
|                 | ``Other         | items <#medical | (Drugs,         |
|                 | fields``:       | -items-administ | Prostheses)->It |
|                 |                 | ration>`__      | ems             |
|                 | Item Code       |                 |                 |
|                 |                 |                 |                 |
|                 | Item Name       |                 |                 |
|                 |                 |                 |                 |
|                 | Item Category   |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Diseases``    | Disease         | `list of        |                 |
|                 | Hierarchy       | diagnoses <#upl |                 |
|                 |                 | oad-list-of-dia |                 |
|                 | ``Other         | gnoses>`__      |                 |
|                 | fields``:       |                 |                 |
|                 |                 |                 |                 |
|                 | Disease Name    |                 |                 |
|                 |                 |                 |                 |
|                 | Disease Code    |                 |                 |
|                 |                 |                 |                 |
|                 | Disease         |                 |                 |
|                 | Category        |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Providers``   | Provider        | `register of    | Hierarchy:      |
|                 | Hierarchy       | health          |                 |
|                 |                 | facilities <#he | Regions->Distri |
|                 | ``Other         | alth-facilities | cts->           |
|                 | fields``:       | -administration | (Dispensary,    |
|                 |                 | >`__            | Health Centre,  |
|                 | Provider Name   |                 | Hospital)       |
|                 |                 |                 | ->Health        |
|                 | Disease Code    |                 | facility        |
|                 |                 |                 |                 |
|                 | Provider        |                 |                 |
|                 | Category        |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ``Care Category | Category Care   | generated by    | Emergency,      |
| ``              |                 | IMIS            | Other,          |
|                 |                 |                 | Referral,       |
|                 |                 |                 | Unknown         |
+-----------------+-----------------+-----------------+-----------------+
| ``Care Type``   | Care Type       | generated by    | In-patient,     |
|                 |                 | IMIS            | Out-patient,    |
|                 |                 |                 | Unknown         |
+-----------------+-----------------+-----------------+-----------------+
| ``Questions``   | Question        | generated by    | Care Rendered,  |
|                 |                 | IMIS            | Drug            |
|                 |                 |                 | Prescribed,     |
|                 |                 |                 | Drug Received,  |
|                 |                 |                 | Payment Aske,   |
|                 |                 |                 | Unknown         |
+-----------------+-----------------+-----------------+-----------------+

Table 9.1 Overview of dimensions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Facts
-----

|image285|\ Facts provided by AR-IMIS can be structured into the areas
according to `Image 9.3 <#image-9.3-areas-of-facts>`__. Within each area
several facts packed into one or several cubes are provided. Facts are
packed into the same cube if they have an associated meaning and are
provided with the same set of dimension. The following articles lists
available cubes according to the areas, for each cube indicates
available facts with description of their meaning and

.. _section-20:

Image 9.3 Areas of facts
^^^^^^^^^^^^^^^^^^^^^^^^

underlying set of qualifying dimensions. If meaning of a dimension is
not straightforward, its description is provided. It relates especially
to the *Time* dimension where it is important which datum related with a
fact is taken as the governing date for association with given point
(period) in the *Time* dimension.

Facts on enrolment and policies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This group of facts relates to acquisition of insures and development of
coverage by health insurance schemes. Facts available are listed in
`Table 9.2 <#table-9.2-facts-on-enrolment-and-policies>`__

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Population  | Population  | Number of   | Gender      |             |
|             |             | inhabitants |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Region      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+
| Number of   | Number of   | Number of   | Region      |             |
| families/gr | families/gr | households  |             |             |
| oups        | oups        | according   |             |             |
|             |             | to a census |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+
| Current and | Current     | Insurees    | Age         | Age at the  |
| new         | insurees    | covered by  |             | end of a    |
| insurees    |             | at least    |             | time period |
|             |             | one policy  |             |             |
|             |             | active at   |             |             |
|             |             | the end of  |             |             |
|             |             | a time      |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Enrolment   | An          |
|             |             |             | Officers    | enrolment   |
|             |             |             |             | officer     |
|             |             |             |             | responsible |
|             |             |             |             | for         |
|             |             |             |             | correspondi |
|             |             |             |             | ng          |
|             |             |             |             | policy      |
+-------------+-------------+-------------+-------------+-------------+
|             | New         | Insurees    | Region      | Place of    |
|             | acquired    | newly       |             | living of a |
|             | insurees    | insured     |             | household   |
|             |             | during a    |             |             |
|             |             | time period |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    | An          |
|             |             |             |             | insurance   |
|             |             |             |             | product     |
|             |             |             |             | covering an |
|             |             |             |             | insuree     |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Period of   |
|             |             |             |             | enrolment   |
|             |             |             |             | of insurees |
|             |             |             |             | for new     |
|             |             |             |             | insurees    |
|             |             |             |             |             |
|             |             |             |             | Period of   |
|             |             |             |             | effective   |
|             |             |             |             | day and     |
|             |             |             |             | later of    |
|             |             |             |             | their       |
|             |             |             |             | policies    |
|             |             |             |             | for current |
|             |             |             |             | insurees    |
+-------------+-------------+-------------+-------------+-------------+
| All types   | Current     | Number of   | Age         | Age of the  |
| of policies | policies    | active      |             | head of a   |
|             |             | policies at |             | household   |
|             |             | the end of  |             | at the end  |
|             |             | a time      |             | of a time   |
|             |             | period      |             | period      |
+-------------+-------------+-------------+-------------+-------------+
|             | Expired     | Number of   | Gender      | Gender of   |
|             | policies    | policies    |             | the head of |
|             |             | that        |             | a household |
|             |             | expired     |             |             |
|             |             | during a    |             |             |
|             |             | time period |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Renewed     | Number of   | Enrolment   | An          |
|             | policies    | policies    | Officers    | enrolment   |
|             |             | that were   |             | officer     |
|             |             | renewed     |             | responsible |
|             |             | during a    |             | for         |
|             |             | time period |             | correspondi |
|             |             |             |             | ng          |
|             |             |             |             | policy      |
+-------------+-------------+-------------+-------------+-------------+
|             | Sold        | Number of   | Region      | Place of    |
|             | policies    | policies    |             | living of a |
|             |             | that were   |             | household   |
|             |             | sold during |             |             |
|             |             | a time      |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    | An          |
|             |             |             |             | insurance   |
|             |             |             |             | product of  |
|             |             |             |             | a policy    |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Period of   |
|             |             |             |             | enrolment   |
|             |             |             |             | date for    |
|             |             |             |             | sold        |
|             |             |             |             | policies    |
|             |             |             |             |             |
|             |             |             |             | Period of   |
|             |             |             |             | expiry date |
|             |             |             |             | for expired |
|             |             |             |             | policies    |
|             |             |             |             |             |
|             |             |             |             | Period of   |
|             |             |             |             | renewal     |
|             |             |             |             | date(when   |
|             |             |             |             | renewing    |
|             |             |             |             | was done)   |
|             |             |             |             | for renewed |
|             |             |             |             | policies    |
|             |             |             |             |             |
|             |             |             |             | Period of   |
|             |             |             |             | effective   |
|             |             |             |             | day and     |
|             |             |             |             | later for   |
|             |             |             |             | current     |
|             |             |             |             | policies    |
+-------------+-------------+-------------+-------------+-------------+
| Share of    | Share of    | =Current    | Gender      |             |
| insured     | insured     | insures /   |             |             |
| population  | population  | Population  |             |             |
|             |             |             |             |             |
|             |             | at the end  |             |             |
|             |             | of a time   |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Region      | Place of    |
|             |             |             |             | living of a |
|             |             |             |             | household   |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    | An          |
|             |             |             |             | insurance   |
|             |             |             |             | product     |
|             |             |             |             | covering an |
|             |             |             |             | insuree     |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+
| Share of    | Number of   | Number of   | Region      | Place of    |
| insured     | insured     | households  |             | living of a |
| families/gr | families/gr | that are    |             | household   |
| oups        | oups        | covered by  |             |             |
|             |             | at least    |             |             |
|             |             | one active  |             |             |
|             |             | policy at   |             |             |
|             |             | the end of  |             |             |
|             |             | a time      |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Share of    | =Number of  | Region      | Place of    |
|             | insured     | insured     |             | living of a |
|             | families/gr | households  |             | household   |
|             | oups        | /Number of  |             |             |
|             |             | households  |             |             |
|             |             |             |             |             |
|             |             | at the end  |             |             |
|             |             | of a time   |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+

Table 9.2 Facts on enrolment and policies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Facts on collected revenue
~~~~~~~~~~~~~~~~~~~~~~~~~~

This group of facts relates to revenue of health insurance schemes.
Facts available are listed in `Table 9.3 <\l>`__.

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Contributio | Contributio | Contributio | Enrolment   | Collection  |
| n           | n           | ns          | Officers    | of          |
| collection  | collected   | collected   |             | contributio |
|             |             | in given    |             | ns          |
|             |             | time period |             | from        |
|             |             |             |             | policies of |
|             |             |             |             | an          |
|             |             |             |             | enrolment   |
|             |             |             |             | officer     |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Payers      | Collection  |
|             |             |             |             | of          |
|             |             |             |             | contributio |
|             |             |             |             | ns          |
|             |             |             |             | from an     |
|             |             |             |             | institution |
|             |             |             |             | al          |
|             |             |             |             | payer or    |
|             |             |             |             | from        |
|             |             |             |             | families    |
|             |             |             |             | itself      |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    | Collection  |
|             |             |             |             | of          |
|             |             |             |             | contributio |
|             |             |             |             | ns          |
|             |             |             |             | within an   |
|             |             |             |             | insurance   |
|             |             |             |             | product     |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Period of   |
|             |             |             |             | payment     |
|             |             |             |             | date of     |
|             |             |             |             | contributio |
|             |             |             |             | ns          |
+-------------+-------------+-------------+-------------+-------------+
| Contributio | Contributio | Amount of   | Products    | Allocation  |
| n           | n           | collected   |             | of          |
| allocation  | allocated   | contributio |             | contributio |
|             |             | ns          |             | ns          |
|             |             | allocated   |             | within an   |
|             |             | proportiona |             | insurance   |
|             |             | lly         |             | product     |
|             |             | for using   |             |             |
|             |             | in a time   |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Period of   |
|             |             |             |             | allocation  |
|             |             |             |             | of          |
|             |             |             |             | contributio |
|             |             |             |             | ns          |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+

Table 9.3 Facts on contributions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Facts on claims
~~~~~~~~~~~~~~~

This group of facts relates to claims forwarded by health care providers
to administrators of health insurance schemes. Facts available are
listed in `Table 9.4 <#table-9.4-facts-on-claims>`__ .

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Claim       | Amount      | Total       | Providers   | Providers   |
| details     | claimed     | amount in   |             | that        |
|             |             | nominal     |             | entered and |
|             |             | prices that |             | or          |
|             |             | was         |             | submitted   |
|             |             | submitted   |             | claims      |
|             |             | by health   |             |             |
|             |             | care        |             |             |
|             |             | providers   |             |             |
|             |             | for health  |             |             |
|             |             | care        |             |             |
|             |             | provided in |             |             |
|             |             | given       |             |             |
|             |             | period      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Amount      | Total       | Time        | Time period |
|             | rejected    | amount that |             | of          |
|             |             | was on      |             | provision   |
|             |             | totally     |             | of health   |
|             |             | rejected    |             | care that   |
|             |             | claims      |             | was         |
|             |             |             |             | invoiced in |
|             |             |             |             | claims      |
+-------------+-------------+-------------+-------------+-------------+
|             | Entered     | Number of   |             |             |
|             | claims      | claims      |             |             |
|             |             | entered     |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Submitted   | Number of   |             |             |
|             | claims      | claims      |             |             |
|             |             | submitted   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Rejected    | Number of   |             |             |
|             | claims      | claims      |             |             |
|             |             | totally     |             |             |
|             |             | rejected    |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | =Amount     |             |             |
|             | amount      | claimed/    |             |             |
|             | claimed     | Submitted   |             |             |
|             |             | claims      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | =Amount     |             |             |
|             | amount      | rejected/   |             |             |
|             | rejected    | Rejected    |             |             |
|             |             | claims      |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Claim       | Amount      | Amount      | Providers   | Providers   |
| details     | adjusted    | adjusted    |             | that        |
| products    |             | after       |             | submitted   |
|             |             | processing  |             | claims      |
|             |             | in nominal  |             |             |
|             |             | prices      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Amount paid | Amount      | Products    | Products by |
|             |             | actually to |             | which       |
|             |             | be paid to  |             | health care |
|             |             | health      |             | claimed was |
|             |             | facilities  |             | covered     |
|             |             | taking into |             |             |
|             |             | account     |             |             |
|             |             | indexes of  |             |             |
|             |             | relative    |             |             |
|             |             | pricing     |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Processed   | Number of   | Time        | Time period |
|             | claims      | claims sent |             | of          |
|             |             | for         |             | provision   |
|             |             | valuation   |             | of health   |
|             |             |             |             | care that   |
|             |             |             |             | was         |
|             |             |             |             | invoiced in |
|             |             |             |             | claims      |
+-------------+-------------+-------------+-------------+-------------+
|             | Paid claims | Number of   |             |             |
|             |             | claims      |             |             |
|             |             | actually    |             |             |
|             |             | valuated    |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | =Amount     |             |             |
|             | amount      | adjusted/Pr |             |             |
|             | adjusted    | ocessed     |             |             |
|             |             | claims      |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | =Amount     |             |             |
|             | amount paid | paid/       |             |             |
|             |             | Valuated    |             |             |
|             |             | claims      |             |             |
+-------------+-------------+-------------+-------------+-------------+

Table 9.4 Facts on claims
^^^^^^^^^^^^^^^^^^^^^^^^^

Facts on utilization of health care
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    This group of facts relates to utilization of health care by insures
    according to submitted and not rejected claims. Facts available are
    listed in `Table
    9.5 <#table-9.5-facts-on-of-utilization-health-care>`__

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Admissions  | Number of   | Number of   | Age         | Age at the  |
| and visits  | hospital    | hospital    |             | time of     |
| and         | admissions  | admissions  |             | provision   |
| hospital    |             |             |             | health care |
| days        |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             | Number of   |             | Care        |             |
|             | hospital    |             | category    |             |
|             | days        |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | = Number of | Products    | In case two |
|             | length of   | hospital    |             | or more     |
|             | stay        | days/       |             | insurance   |
|             |             | Number of   |             | products    |
|             |             | hospital    |             | covered a   |
|             |             | admissions  |             | hospital    |
|             |             |             |             | admission/v |
|             |             |             |             | isit,       |
|             |             |             |             | it is       |
|             |             |             |             | accounted   |
|             |             |             |             | to each of  |
|             |             |             |             | them        |
+-------------+-------------+-------------+-------------+-------------+
|             | Number of   |             | Providers   | Providers   |
|             | out-patient |             |             | which       |
|             | visits      |             |             | claimed     |
|             |             |             |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Utilization | Services    | Number of   | Age         | Age at the  |
| of services | utilized    | utilized    |             | time of     |
|             |             | services    |             | provision   |
|             |             | according   |             | health care |
|             |             | to          |             |             |
|             |             | submitted   |             |             |
|             |             | claims.     |             |             |
|             |             |             |             |             |
|             |             | If a        |             |             |
|             |             | service was |             |             |
|             |             | provided    |             |             |
|             |             | during one  |             |             |
|             |             | visit/hospi |             |             |
|             |             | tal         |             |             |
|             |             | stay, the   |             |             |
|             |             | service is  |             |             |
|             |             | counted     |             |             |
|             |             | according   |             |             |
|             |             | to the      |             |             |
|             |             | number of   |             |             |
|             |             | its         |             |             |
|             |             | provision   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care        |             |
|             |             |             | category    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care type   |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Providers   | Providers   |
|             |             |             |             | which       |
|             |             |             |             | claimed     |
|             |             |             |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Services    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Utilization | Items       | Number of   | Age         | Age at the  |
| of medical  | utilized    | utilized    |             | time of     |
| items       |             | medical     |             | provision   |
|             |             | items       |             | health care |
|             |             | according   |             |             |
|             |             | to          |             |             |
|             |             | submitted   |             |             |
|             |             | claims      |             |             |
|             |             |             |             |             |
|             |             | If a        |             |             |
|             |             | medical     |             |             |
|             |             | item was    |             |             |
|             |             | provided    |             |             |
|             |             | during one  |             |             |
|             |             | visit/hospi |             |             |
|             |             | tal         |             |             |
|             |             | stay, the   |             |             |
|             |             | medical     |             |             |
|             |             | item is     |             |             |
|             |             | counted     |             |             |
|             |             | according   |             |             |
|             |             | to the      |             |             |
|             |             | number of   |             |             |
|             |             | its         |             |             |
|             |             | provision   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care        |             |
|             |             |             | category    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care type   |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Providers   | Providers   |
|             |             |             |             | which       |
|             |             |             |             | claimed     |
|             |             |             |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Items       |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Average     | Average     | = Services  | Age         | Age at the  |
| utilization | utilization | utilized /  |             | time of     |
| of services | of services | Current     |             | provision   |
| per insuree | per insuree | insurees    |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Services    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Average     | Average     | = Items     | Age         |             |
| utilization | utilization | utilized /  |             |             |
| of medical  | of medical  | Current     |             |             |
| items per   | items per   | insurees    |             |             |
| insuree     | insuree     |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Items       |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        |             |
+-------------+-------------+-------------+-------------+-------------+

Table 9.5 Facts on of utilization health care
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Facts on expenditures for health care
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    This group of facts relates to expenditures for health care actually
    paid to health care providers. Facts available are listed in `Table
    9.6 <#table-9.6-facts-on-expenditures-for-health-care>`__

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Expenditure | Service     | Expenditure | Age         | Age at the  |
| s           | expenditure | s           |             | time of     |
| for         | s           | for         |             | provision   |
| services    |             | services    |             | health care |
|             |             | actually    |             |             |
|             |             | remunerated |             |             |
|             |             | to health   |             |             |
|             |             | facilities  |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care        |             |
|             |             |             | category    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care type   |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Providers   | Providers   |
|             |             |             |             | which       |
|             |             |             |             | claimed     |
|             |             |             |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Services    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Expenditure | Item        | Expenditure | Age         | Age at the  |
| s           | expenditure | s           |             | time of     |
| for medical | s           | for medical |             | provision   |
| items       |             | items       |             | health care |
|             |             | actually    |             |             |
|             |             | remunerated |             |             |
|             |             | to health   |             |             |
|             |             | facilities  |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care        |             |
|             |             |             | category    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Care type   |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Providers   | Providers   |
|             |             |             |             | which       |
|             |             |             |             | claimed     |
|             |             |             |             | health care |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Items       |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Average     | Average     | = Service   | Age         | Age at the  |
| expenditure | expenditure | expenditure |             | time of     |
| s           | s           | s/          |             | provision   |
| for         | for         | Current     |             | health care |
| services    | services    | insurees    |             |             |
| per insuree | per insuree |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Services    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Average     | Average     | = Item      | Age         | Age at the  |
| expenditure | expenditure | expenditure |             | time of     |
| s           | s           | s/          |             | provision   |
| for medical | for medical | Number of   |             | health care |
| items per   | items per   | inhabitants |             |             |
| insuree     | insuree     |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     | .           |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Items       |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+
| Average     | Average     | = Average   | Age         | Age at the  |
| expenditure | expenditure | expenditure |             | time of     |
| s           | s           | s           |             | provision   |
| for health  | per insuree | of services |             | health care |
| care per    |             | per insuree |             |             |
| insuree     |             | + Average   |             |             |
|             |             | expenditure |             |             |
|             |             | s           |             |             |
|             |             | for medical |             |             |
|             |             | items per   |             |             |
|             |             | insuree     |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Gender      |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Disease     |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Products    |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Hospital    |
|             |             |             |             | admissions  |
|             |             |             |             | are         |
|             |             |             |             | associated  |
|             |             |             |             | with time   |
|             |             |             |             | periods     |
|             |             |             |             | according   |
|             |             |             |             | to dates of |
|             |             |             |             | discharge.  |
|             |             |             |             | Time period |
|             |             |             |             | of          |
|             |             |             |             | provision   |
|             |             |             |             | of health   |
|             |             |             |             | care        |
+-------------+-------------+-------------+-------------+-------------+

Table 9.6 Facts on expenditures for health care
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Facts on feedbacks
~~~~~~~~~~~~~~~~~~

    This group of facts relates to evaluation of request for feedbacks
    on provided health care that are issued by medical officers during
    processing of claims. Facts available are listed in `Table
    9.7 <\l>`__

+-------------+-------------+-------------+-------------+-------------+
| Cube        | Fact        | Meaning     | Dimension   | Comment     |
+=============+=============+=============+=============+=============+
| Feedback    | Feedbacks   | Number of   | Products    | Insurance   |
| details     | sent        | requests    |             | products    |
|             |             | for         |             | that        |
|             |             | feedbacks   |             | covered     |
|             |             | sent in a   |             | claims      |
|             |             | time period |             | initiating  |
|             |             |             |             | requests    |
|             |             |             |             | for         |
|             |             |             |             | feedbacks   |
+-------------+-------------+-------------+-------------+-------------+
|             | Feedbacks   | Number of   | Providers   | Providers   |
|             | responded   | feedbacks   |             | that        |
|             |             | received in |             | submitted   |
|             |             | a time      |             | claims      |
|             |             | period      |             | initiating  |
|             |             |             |             | requests    |
|             |             |             |             | for         |
|             |             |             |             | feedbacks   |
+-------------+-------------+-------------+-------------+-------------+
|             | Overall     | Sum of all  | Time        | Period of   |
|             | assessment  | assessment  |             | sending/rec |
|             |             | overall     |             | eiving      |
|             |             | assessment  |             | feedbacks   |
|             |             | marks in    |             |             |
|             |             | responded   |             |             |
|             |             | feedbacks   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Feedback    | = Feedbacks |             |             |
|             | return      | responded/  |             |             |
|             | share       | Feedbacks   |             |             |
|             |             | sent        |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Average     | = Overall   |             |             |
|             | overall     | assessment/ |             |             |
|             | assessment  | Feedbacks   |             |             |
|             |             | responded   |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Feedback    | Answers Yes | Count of    | Products    | Insurance   |
| answers     |             | all Yes     |             | products    |
|             |             | answers     |             | that        |
|             |             |             |             | covered     |
|             |             |             |             | claims      |
|             |             |             |             | initiating  |
|             |             |             |             | requests    |
|             |             |             |             | for         |
|             |             |             |             | feedbacks   |
+-------------+-------------+-------------+-------------+-------------+
|             | Share of    | = Answers   | Providers   | Providers   |
|             | Answers Yes | Yes/        |             | that        |
|             |             | Feedbacks   |             | submitted   |
|             |             | responded   |             | claims      |
|             |             |             |             | initiating  |
|             |             |             |             | requests    |
|             |             |             |             | for         |
|             |             |             |             | feedbacks   |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Questions   |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             | Time        | Period of   |
|             |             |             |             | sending/rec |
|             |             |             |             | eiving      |
|             |             |             |             | feedbacks   |
+-------------+-------------+-------------+-------------+-------------+

Table 9.7 Facts on feedbacks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How access data from the Data Warehouse
---------------------------------------

Data from the Data Warehouse can be accessed by means of an Excel file.
As access to the Data Warehouse is protected, a user has to get from an
administrator of AR-MIS URL of the Data Warehouse for remote access, a
userid and a password. A userid may allow access to all data in the Data
Warehouse or only to a subset of data corresponding to a specific
region, to selected regions, to a specific district or to selected
districts.

The procedure of accessing of data is as follows `(Image
9.8) <#image-9.8-accessing-the-data-warehouse>`__

|image286|\ Image 9.8 Accessing the Data Warehouse
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Open an Excel file

2. Click on the menu item ``*Data``*

3. Click on the sub-menu ``*From Other Sources``*

4. Click on the sub-menu ``*From Analysis Services``*

5. A dialog box appears for specification of logon data:

   a. Enter URL of the Data Warehouse into the field ``*Server Name``*

   b. Select the option ``*Use the following user name and password``*

   c. Enter your userid into the field ``*User Name``*

   d. Enter your password into the field ``*Password``*

   e. Click on ``*Finish``*

6. A box appears (``*Select Database and Tables``*) with the list of
   available cubes. Select one and click on ``*Finish``*

7. A box appears (``*Save Data Connection File and Finish``*).Check the
   box ``*Save passport in file``* and click on ``*Finish``*.

8. A box appears (``*Import Data``*). Select whether cube should be
   accessed by a pivot table and/or chart and specify a placement of the
   pivot table. Click on ``OK``.

9. An area for the pivot table appears in the sheet with the ``*Pivot
   Table Field``* area on the right `(Image
   9.9) <#image-9.9-pivot-table-in-excel>`__ . Click on facts to be
   displayed and click or drag dimensions to appropriate sectors of the
   pivot table in the ``Pivot Table Field`` area.
