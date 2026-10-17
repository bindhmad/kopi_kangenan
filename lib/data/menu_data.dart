import '../models/menu_item.dart';

class MenuData {
  MenuData._();

  static const List<MenuItem> specialsToday = [
    MenuItem(
      id: 'sp_1',
      name: '2 KKM Hanya 29.900',
      category: 'promo',
      price: 29900,
      originalPrice: 45000,
      badge: 'Promo Delivery',
      description: '2 signature kopi susu kangenan segar manis aren mantap.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDkU8NdDmS_OVhO83IeZQhjbYH4CI_9lGXua-9hzq7OtiSGQLuXy_u0BNYaXPz0RE90XsrI2Kdquix8unygEl8BHYNvYUS6VKMvlY-CX7hRqUWj5Og0oGGo2zILzAztQhiEZK2MI2O7CyKwiWwRbMwvkhsGKxu0sKUNBuFfurga3iIGk6pM-XuJm9lQrnY5Zm0DYulX9EAhyLC5JbLcNQ9fJQV93uKKzCWYgiLWmQ5pUv3kL25x8FwTCw',
    ),
    MenuItem(
      id: 'sp_2',
      name: 'Kangen Aren Latte Twin',
      category: 'promo',
      price: 24500,
      originalPrice: 38000,
      badge: 'Promo Delivery',
      description: 'Dua cup latte aren dengan susu segar dan espresso harum.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDsE5YNbCVmmtXkrvF8TT0JD1mNRXAsdEQxv-dE9NZbUANpbBwteaMiM0a0EcN020aiVaWsaZf4-7BbD8JfSAslDDVBfWPldcPGpquTzX7FhMW8qxCObbBZlllWh4eRNaNFqrRaJTZlDbVf1rbeW1pCitvjvxMYKgcENv7PptDftBSP4GUvPORUl5TgkX4FzGNBrcHStD-Eni-aZjQVVvpuklWV3-0WbgkUc3p_gqjXVdmQw1AYYMSthw',
    ),
    MenuItem(
      id: 'sp_3',
      name: 'Avocado Coffee Float',
      category: 'promo',
      price: 19900,
      originalPrice: 32000,
      badge: 'Promo Delivery',
      description: 'Espresso creamy dengan puree alpukat dan es krim vanilla.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDD8vo8W3KAYx-2mocIJL2Lp-jL-Fj3_VrffDgSa4AblqneFyLl7jkp81bB0YuRIhdhOzI9wcWV2eDVsfigk-uUeX7oAKA40uzujDmRady6zELwhT7LxAWRqsDRV8VmgYPZC34b6mCtnqoxRshm8NiwoqK707V3B2cwzjMrs_2Ygzdz-1DEwgClFR0eLRdqxv-XzrHUBmZQsSjfn7KI9Ox1uFZ7NNcrSNAtDqyrqTiDq-3L0nCwhT7qqw',
    ),
  ];

  static const List<MenuItem> coffeeItems = [
    MenuItem(
      id: 'cof_1',
      name: 'OG Aren Spesial Latte',
      category: 'coffee',
      price: 24000,
      badge: 'Best Seller',
      description: 'Espresso, susu segar, aren asli',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBeIt14XqQpNbDIWKDH3pVE95QAxRdYOueOgzynMsn67KPwj41FcsiKtoKPUc-rvcLjQ1s45aXYc5NLCmWUviL-qviWyH2TWkqbEqNdEhnjJa2KbuxSH9jyBdrYr9dZJr1Lja8uFUdeBM45jTlAPb4g9Nnf0QRSJ7-81rW1WR_EYkvUT7bP164LvS0-PlW2E-cvyZZXyr26dBD6BktGQCLoKwb91NXsLV495WNcjpAaWozxwYTRGeZhpg',
    ),
    MenuItem(
      id: 'cof_2',
      name: 'Dua Shot OG Aren',
      category: 'coffee',
      price: 28000,
      badge: 'Extra Strong',
      description: 'Double espresso mantap untuk booster harimu',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA4tk75rLp04k1dTB-jk7xv1TP04nxTus_FIjJSswn6_m_thP7wDhIFOWNrWw79N6c4lC1feQFeUOwW6_S3ntAa6YosOyQp7Q2KEswg-D5ipWEkQ3jy_oGGTWKlF-rIWwT1vQzlqeJTt-_iUA5dbpWuA87-l_bORC3aLY-a0aRcHtrxcVZNm5ShfMcjbcI2AI8cxlkL9j1-QSL7x_CYC_tQJ3zK5ffks4EHe4YgHGpE43DdU_sN1Cz0LQ',
    ),
    MenuItem(
      id: 'cof_3',
      name: 'Pistachio Aren Latte',
      category: 'coffee',
      price: 22000,
      description: 'Aroma kacang pistachio gurih dengan manis aren',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA9Nr8gAu3Lze3G2-LnYj6u0_QryEne_fIlCpLmGA-aOnx_ECKSuTZifMnqIJEYQiPqRq59eQCEr98EVwoaLhEfhLMs4SmrqKX9k2MYxN8TsUwf9Lm2J7VEBTgtzobJKpyYCrMTWUASacL9CadT1kE4E8S4STkzJ-Y0yiNlCkgmiFZv-rHCgrv4wLUrZRtOz6EfHpicIPXBwnklLmkeh1oE2Vh9Uo8jnz0ClkIoyx8eXhAoCRKG7KUZUA',
    ),
    MenuItem(
      id: 'cof_4',
      name: 'Cafe Malt Latte',
      category: 'coffee',
      price: 26000,
      description: 'Malt gandum & cokelat lembut berpadu espresso',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQWeFHsDuB3QlabV_HnMUycv9qQblHD3MkRhh47ym63-wJsZbYM99whvDE2HRRid_z_W_MWCy8zYdmHwnh90ckDb0sAFT26jd9V-iWrYjOJIbf2iKQSU0MllNGX6ZTT3H92Hpj-YR4oFntxCi7le6j7SYHHjyeBJZVsUMmTYeMO7vfvgKMDY8CDPy9ZHbsLlbr5XrG5n_bnysos7zz3Z5t1Ir6-p6dzPCMjVgCuOxqs_to_LCedzFZVA',
    ),
    MenuItem(
      id: 'cof_5',
      name: 'Kopi Kangenan Mantan',
      category: 'coffee',
      price: 22000,
      badge: 'Favorit',
      description: 'Manis kenangan rasa legendaris kopi susu klasik',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAcG1HfGAeBglVvwE2obo-jiMkynMd1BEPfXQf_2yJdlJ2E4XOGfLCaRJEsfgUAsjuvXKRylYmhUqFaBv1BpML1Gex8xOxF6Or3Cj9wRbHRT8zQtAUua6SN4hNgA61CpQxqxjKGMS7V7aF8m5F2ulU5ddgEewOfDfyn69uZkWgjRAkxpdfPTNXVCDvGn6aQRkHJRWuDHKaBbjKymV5X2sjofkaF_Fxrm7mLTaWXN_5Aa7FyrJFaccJ3FQ',
    ),
    MenuItem(
      id: 'cof_6',
      name: 'Caramel Latte',
      category: 'coffee',
      price: 28000,
      description: 'Saus karamel legit & espresso arabika spesial',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAe0I7bG0t0qZR50rgipp5dZjaVi8zylBip6tjDbGjzEm-uNHlPnYzT6gN6RlQ4x7qEIauyAPufS_RgIPtZ-btTNuuIXguIySJdu2hAX5lPjuQbKyf07G22XOVO3VYHxkkgI3vCiWAJdmAQaXtu8OeO45hKgu7UPaIV-Fysm2n2qX22kln6n7MHl7x_JuV1gRqETkaE5_t9S_YjbAjB8J4Z4SEsLJhbIAWbO0ROM-j7aIsLvSYG-iSjYA',
    ),
  ];

  static const List<MenuItem> foodItems = [
    MenuItem(
      id: 'food_1',
      name: 'Triple Cheese Bagel',
      category: 'food',
      price: 22000,
      badge: 'New',
      description: 'Gurih, renyah di luar lembut di dalam dengan melted cheese',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBKU0oUvXPPx3OrXyJpQJtyEa5BbppfI-0ZBzj8k6_NXIuUpyb71VWdybNUSTWXwhKpIzm4HBb4YxDrqH7dtcverITR8puYLaEkahJBYbqmQsoZdwizpbV_ETk-L6va6Y0EBoaOFj2-QzJvR6R0p1mjHojm4VWOCR4twoTwci_tKC8MRZP3FNgxSQWqXPo4wS2tonjMATKxZG9mhtSuwBvXJzdDsiY4sD_ByWPQ5sGNX0FM8nOLZ782rQ',
    ),
    MenuItem(
      id: 'food_2',
      name: 'Beef & Cheese Jalapeño',
      category: 'food',
      price: 24000,
      badge: 'New',
      description: 'Daging sapi berbumbu, keju meleleh, dan sentuhan pedas jalapeño',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBDoVOMAzKwy5sfbQUctAzQEwghziQQKfLkrcRQ3KpG_caUyxSl7QIkkilypzfxun7mxj1AvNrmW-HXqiVXWEn-4GrWNKg9T3U-5ozvVEWvJIoX13aaw8n9iSNmKgJ1F7MMmgvC4CsiX6M87-lweX5hPac9gEehXJb8P9RUkh0AkYXBj1ZkV6pkuePbP_1t5YwQYJNMRJKlipmFkNZu9FMuzvc4bPdgY34R8UHpymfKzLOIymSAV6iXBg',
    ),
    MenuItem(
      id: 'food_3',
      name: 'Double Choco Bagel',
      category: 'food',
      price: 22000,
      badge: 'New',
      description: 'Bagel cokelat ganda dengan lelehan dark chocolate chips',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ-XX90CRhkrpDQhvyUuQP17gbBqx6ZBgpbQWeEKiXK-juUcwPOlMC7nop4PPlWQ3JWRVuWiWU1nFMo6atNux87AM6lKNWAovEBoUJm3MaC8bkLfa7e0XGO_udlkJXL5ZTfWsU678nQFemgAQZ--08by10-in-g7mED9A4LEq3tDB3D79uUlJblp_RwQ25dfKediC2B-Yuz7px-NZEqU6KMWU03Jv7g8wRIpyrphejKdaKk-SDUxl3og',
    ),
    MenuItem(
      id: 'food_4',
      name: 'Butter Croissant',
      category: 'food',
      price: 15000,
      description: 'Croissant renyah berlapis dengan mentega Prancis aromatik',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_SwVlDGE5F-s1-CymgMVRgfhKqBEyxRqHm7z4IZqwlwOor5_xVS3Vdfi9ytdWLd7Q9u_x3aQaM1VmGGR9XR9JR2iqX7fWL_iK5KTRFIVAha8d565NMPkFznsXg27Bbsyy8f315cK-_rwC-meBFwTbBwTisj6puWTm6BjUiUtsxLXxHs-fqCKAdSsalKXiOuF6sYg5wvdBvHHVCHMLYlbLmskFE8i6E3-Gm_Rflpj-KOckQImPCkE4QQ',
    ),
    MenuItem(
      id: 'food_5',
      name: 'Chocolate Croissant',
      category: 'food',
      price: 19000,
      description: 'Pain au chocolat renyah dengan isian cokelat Belgia kaya rasa',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAadZf59_FmHferv89ETAkm3xBaq_3dPxk-UWsuwWhoK-dscPcqPo9H00iOtqv1MoVwVDe_HozsaJ0fmJCZo43pCj6bMI-6uLweXQSGAbPyBb09c45NtcuZ2QPfKS1NgAyIJvqOVd23orb5jTc6gS8JB2o8S4aSanpfkTcPntKmt-J6zR548KzNPTPXwVOzXT2fJ5XO6V2vWWCRn_paVwa_Zhu_22_ZpUnNVqhhPRloMQpEvJd0mEjpXw',
    ),
    MenuItem(
      id: 'food_6',
      name: 'Chocolate Donut',
      category: 'food',
      price: 13000,
      description: 'Donat brioche empuk bertabur lelehan cokelat tebal',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCkbiIxDrElHy89M1ahI58WLBqU40GP-KMYC50Nkro3slct6MeUg3wX84_GYQhjPupxoR1tQOinHv8VaZSNe8Ga_fo7dXZqk_l1r0Na77GfxGCC31faZFRMglxNKh4uDDlIlAc3qPDD7v0eQggi9kC3Vl9Nu2lCH0OXAIVl_vV-8EPmOhiG2sow_lp2SLS8MPh-xP5pXgLimk3Wrem7BXwgDneY0KSV2FQ3euwPspaAv0utmMB9CMbKpw',
    ),
  ];
}
