class LicenceScraper
  def self.scrape_text(readme)
    new.scrape_text(readme)
  end

  def scrape_text(readme)
    licence_section = false

    readme.lines.each do |line|
      line = line.strip
      next if line.empty?

      if starts_licence_section?(line)
        return true
      end

      if looks_licency?(line)
        # Compare line to known licences
        normalised = line.gsub(symbols, '')

        valid_licences.each do |valid_licence|
          if normalised.include?(valid_licence)
            logger.debug("LICENCE LINE: #{valid_licence} [#{line}]")
            return true
          end
        end
      end
    end

    false
  end

  def valid_licences
    # From https://opensource.org/licenses/alphabetical
    [
      "2-clause BSD License (BSD-2-Clause)",
      "3-clause BSD License (BSD-3-Clause)",
      "Academic Free License 3.0 (AFL-3.0)",
      "Adaptive Public License (APL-1.0)",
      "Apache License 2.0 (Apache-2.0)",
      "Apple Public Source License (APSL-2.0)",
      "Artistic License 2.0 (Artistic-2.0)",
      "Attribution Assurance License (AAL)",
      "BSD License",
      "Boost Software License (BSL-1.0)",
      "CeCILL License 2.1 (CECILL-2.1)",
      "Computer Associates Trusted Open Source License 1.1 (CATOSL-1.1)",
      "Common Development and Distribution License 1.0 (CDDL-1.0)",
      "Common Public Attribution License 1.0 (CPAL-1.0)",
      "CUA Office Public License Version 1.0 (CUA-OPL-1.0)",
      "EU DataGrid Software License (EUDatagrid)",
      "Eclipse Public License 1.0 (EPL-1.0)",
      "eCos License version 2.0",
      "Educational Community License, Version 2.0 (ECL-2.0)",
      "Eiffel Forum License V2.0 (EFL-2.0)",
      "Entessa Public License (Entessa)",
      "European Union Public License, Version 1.1 (EUPL-1.1)",
      "Fair License (Fair)",
      "Frameworx License (Frameworx-1.0)",
      "Free Public License 1.0.0",
      "GNU Affero General Public License version 3 (AGPL-3.0)",
      "GNU General Public License version 2 (GPL-2.0)",
      "GNU General Public License version 3 (GPL-3.0)",
      "GNU Lesser General Public License version 2.1 (LGPL-2.1)",
      "GNU Lesser General Public License version 3 (LGPL-3.0)",
      "Historical Permission Notice and Disclaimer (HPND)",
      "IBM Public License 1.0 (IPL-1.0)",
      "IPA Font License (IPA)",
      "ISC License (ISC)",
      "LaTeX Project Public License 1.3c (LPPL-1.3c)",
      "Licence Libre du Québec – Permissive (LiLiQ-P) version 1.1",
      "Licence Libre du Québec – Réciprocité (LiLiQ-R) version 1.1",
      "Licence Libre du Québec – Réciprocité forte (LiLiQ-R+) version 1.1",
      "Lucent Public License Version 1.02 (LPL-1.02)",
      "MirOS Licence (MirOS)",
      "Microsoft Public License (MS-PL)",
      "Microsoft Reciprocal License (MS-RL)",
      "MIT License (MIT)",
      "Motosoto License (Motosoto)",
      "Mozilla Public License 1.0 (MPL-1.0)",
      "Mozilla Public License 1.1 (MPL-1.1)",
      "Mozilla Public License 2.0 (MPL-2.0)",
      "Multics License (Multics)",
      "NASA Open Source Agreement 1.3 (NASA-1.3)",
      "NTP License (NTP)",
      "Naumen Public License (Naumen)",
      "Nethack General Public License (NGPL)",
      "Nokia Open Source License (Nokia)",
      "Non-Profit Open Software License 3.0 (NPOSL-3.0)",
      "OCLC Research Public License 2.0 (OCLC-2.0)",
      "Open Group Test Suite License (OGTSL)",
      "Open Software License 3.0 (OSL-3.0)",
      "OSET Public License version 2.1",
      "PHP License 3.0 (PHP-3.0)",
      "The PostgreSQL License (PostgreSQL)",
      "Python License (Python-2.0)",
      "CNRI Python license (CNRI-Python)",
      "Q Public License (QPL-1.0)",
      "RealNetworks Public Source License V1.0 (RPSL-1.0)",
      "Reciprocal Public License 1.5 (RPL-1.5)",
      "Ricoh Source Code Public License (RSCPL)",
      "SIL Open Font License 1.1 (OFL-1.1)",
      "Simple Public License 2.0 (SimPL-2.0)",
      "Sleepycat License (Sleepycat)",
      "Sun Public License 1.0 (SPL-1.0)",
      "Sybase Open Watcom Public License 1.0 (Watcom-1.0)",
      "University of Illinois/NCSA Open Source License (NCSA)",
      "Universal Permissive License (UPL)",
      "Vovida Software License v. 1.0 (VSL-1.0)",
      "W3C License (W3C)",
      "wxWindows Library License (WXwindows)",
      "X.Net License (Xnet)",
      "Zero Clause BSD License (0BSD)",
      "Zope Public License 2.0 (ZPL-2.0)",
      "zlib/libpng license (Zlib)",
    ].flat_map do |name|
      match = /(?<long_name>.*) \((?<short_name>.*)\)/.match(name)
      if match.nil?
        [name.gsub(symbols, '')]
      else
        [match[:long_name].gsub(symbols, ''), match[:short_name]]
      end
    end
  end

  def symbols
    /[^A-Za-z0-9\s]/
  end

  # Check for markdown "# Licence" heading
  def starts_licence_section?(line)
    /^#+\s*li[sc]en[sc]e/i =~ line
  end

  # If the line mentions licences, it probably contains the licence
  def looks_licency?(line)
    /li[sc]en[sc]e/i =~ line
  end

private
  def logger
    Rails.logger
  end
end
