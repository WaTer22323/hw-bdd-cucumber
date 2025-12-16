Feature: display list of movies filtered by MPAA rating

  As a concerned parent
  So that I can quickly browse movies appropriate for my family
  I want to see movies matching only certain MPAA ratings

Background: movies have been added to database

  Given the following movies exist:
  | title                   | rating | release_date |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |
  | The Help                | PG-13  | 10-Aug-2011  |
  | Chocolat                | PG-13  | 5-Jan-2001   |
  | Amelie                  | R      | 25-Apr-2001  |
  | 2001: A Space Odyssey   | G      | 6-Apr-1968   |
  | The Incredibles         | PG     | 5-Nov-2004   |
  | Raiders of the Lost Ark | PG     | 12-Jun-1981  |
  | Chicken Run             | G      | 21-Jun-2000  |

  And I am on the RottenPotatoes home page
  Then 10 seed movies should exist

Scenario: restrict to movies with "PG" or "R" ratings
  When I check the following ratings: PG, R
  Scenario: restrict to movies with "PG" or "R" ratings
  # 1. เลือก Rating ที่ต้องการ (PG, R)
  When I check the following ratings: PG, R
  # 2. เอาติ๊ก Rating ที่ไม่ต้องการออก (G, PG-13)
  And I uncheck the following ratings: G, PG-13
  # 3. กดปุ่ม Refresh เพื่อกรองข้อมูล
  And I press "Refresh"
  # 4. ตรวจสอบว่าต้อง 'เจอ' หนังที่เป็น PG และ R
  Then I should see the following movies: The Incredibles, Raiders of the Lost Ark, The Terminator, When Harry Met Sally, Amelie
  # 5. ตรวจสอบว่าต้อง 'ไม่เจอ' หนังที่เป็น G และ PG-13
  And I should not see the following movies: Aladdin, The Help, Chocolat, 2001: A Space Odyssey, Chicken Run

Scenario: all ratings selected
  # 1. เลือกทุก Rating
  When I check the following ratings: G, PG, PG-13, R
  # 2. กดปุ่ม Refresh
  And I press "Refresh"
  # 3. ตรวจสอบว่าต้องเจอหนังครบทุกเรื่อง
  Then I should see all the movies

Scenario: all ratings selected
  Scenario: all ratings selected
  Given I am on the RottenPotatoes home page
  When I check the following ratings: G, PG, PG-13, NC-17, R
  And I press "Refresh"
  Then I should see all the movies


