# Data Sources

This project uses data from the U.S. Census Bureau, Google Trends, Major League Cricket, the International Cricket Council (ICC), and LA28. This file lists the main sources used to build the datasets in the repository. For more detail on how I used the data and the limitations of my analysis, see the README.

## U.S. Census Bureau

**Dataset:** 2024 American Community Survey (ACS) 5-Year Estimates  
**Geography:** Metropolitan Statistical Areas (MSAs)

Tables used:

- **B05006 — Place of Birth for the Foreign-Born Population in the United States**
- **B01003 — Total Population**

I used B05006 for the foreign-born population estimates included in my cricket-connected measure and B01003 for the total population of each metro area.

Official sources:

- B05006: https://data.census.gov/table/ACSDT5Y2024.B05006
- B01003: https://data.census.gov/table/ACSDT5Y2024.B01003

## Google Trends

**Topic:** Cricket - Sport  
**Years:** 2023, 2024, 2025  
**Geography:** United States / Designated Market Areas (DMAs)

Data collected:

- Geographic interest for U.S. markets
- Nationwide weekly interest over time

Google Trends documentation:

- Exporting and citing Trends data: https://support.google.com/trends/answer/4365538
- Trends data and normalization: https://support.google.com/trends/answer/4365533
- Regional interest: https://support.google.com/trends/answer/4355212

## Major League Cricket

Used for:
- MLC franchise markets
- 2026 match locations

Official sources:
- Teams: https://www.majorleaguecricket.com/teams
- 2026 fixtures: https://www.majorleaguecricket.com/matches/fixtures

## 2024 ICC Men's T20 World Cup

Used for:
- U.S. host markets
- Official U.S. fan park locations

Official sources:
- U.S. host venues: https://www.icc-cricket.com/media-releases/dallas-florida-and-new-york-confirmed-as-hosts-of-icc-mens-t20-world-cup-2024
- U.S. venue overview: https://www.icc-cricket.com/tournaments/t20cricketworldcup/news/big-apple-realities-building-on-foundations-elsewhere-a-look-at-new-york-dallas-and-lauderhill-venues-for-the-t20-world-cup
- Fan parks: https://www.icc-cricket.com/tournaments/t20cricketworldcup/fans/fan-parks

## LA28

Used for the planned Olympic cricket venue in Pomona, California.

Official sources:
- Fairgrounds Cricket Stadium: https://la28.org/en/games-plan/venues/fairgrounds-cricket-stadium.html
- Cricket at LA28: https://la28.org/en/games-plan/olympics/cricket.html

## Methodology note

The README explains how I defined the cricket-connected population measure, matched Google Trends DMAs with Census MSAs, compared Trends results across years, and interpreted the infrastructure and event data.
