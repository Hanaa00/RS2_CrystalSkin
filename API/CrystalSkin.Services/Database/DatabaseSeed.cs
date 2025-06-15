using CrystalSkin.Core.Entities;

namespace CrystalSkin.Services.Database;

public partial class DatabaseContext
{
    public void Initialize()
    {
        if (Database.GetAppliedMigrations()?.Count() == 0)
            Database.Migrate();
    }

    private readonly DateTime _dateTime = new(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local);
    private void SeedData(ModelBuilder modelBuilder)
    {
        SeedCountries(modelBuilder);
        SeedCities(modelBuilder);
        SeedMedicalRecords(modelBuilder);
        SeedUsers(modelBuilder);
        SeedNotifications(modelBuilder);
        SeedRoles(modelBuilder);
        SeedUserRoles(modelBuilder);
        SeedServices(modelBuilder);
        SeedProductCategoriesAndProducts(modelBuilder);
        SeedOrders(modelBuilder);
    }

    private void SeedCountries(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Country>().HasData(
             new Country
             {
                 Id = 1,
                 Abrv = "BiH",
                 DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                 IsActive = true,
                 IsDeleted = false,
                 Name = "Bosna i Hercegovina"
             },
              new Country
              {
                  Id = 2,
                  Abrv = "HR",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Hrvatska"
              },
              new Country
              {
                  Id = 3,
                  Abrv = "SRB",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Srbija"
              },
              new Country
              {
                  Id = 4,
                  Abrv = "CG",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Crna Gora"
              },
            new Country
            {
                Id = 5,
                Abrv = "MKD",
                DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                IsActive = true,
                IsDeleted = false,
                Name = "Makedonija"
            });

    }
    private void SeedCities(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<City>().HasData(
            new()
            {
                Id = 1,
                Name = "Mostar",
                Abrv = "MO",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 2,
                Name = "Sarajevo",
                Abrv = "SA",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 3,
                Name = "Jajce",
                Abrv = "JC",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 4,
                Name = "Tuzla",
                Abrv = "TZ",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 5,
                Name = "Zagreb",
                Abrv = "ZG",
                CountryId = 2,
                IsActive = true,
                DateCreated = _dateTime
            });
    }
    private void SeedUsers(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().HasData(
            new User
            {
                Id = 1,
                IsActive = true,
                Email = "site.admin@crystal_skin.com",
                NormalizedEmail = "SITE.ADMIN@CRYSTAL_SKIN.COM",
                UserName = "site.admin",
                NormalizedUserName = "SITE.ADMIN",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1999, 5, 5),
                FirstName = "Site",
                LastName = "Admin",
                Gender = Gender.Male,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 2,
                IsActive = true,
                Email = "doctor@mail.com",
                NormalizedEmail = "DOCTOR@MAIL.COM",
                UserName = "doctor",
                NormalizedUserName = "DOCTOR",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(2005, 5, 5),
                FirstName = "Doctor",
                LastName = "1",
                Gender = Gender.Male,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 3,
                IsActive = true,
                Email = "patient1@mail.com",
                NormalizedEmail = "PATIENT1@MAIL.COM",
                UserName = "patient1",
                NormalizedUserName = "patient1",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1999, 5, 5),
                FirstName = "Patient",
                LastName = "1",
                Gender = Gender.Male,
                DateCreated = _dateTime,
                MedicalRecordId = 1
            },
            new User
            {
                Id = 4,
                IsActive = true,
                Email = "patient2@mail.com",
                NormalizedEmail = "PATIENT2@MAIL.COM",
                UserName = "patient2",
                NormalizedUserName = "PATIENT2",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1979, 5, 5),
                FirstName = "Patient",
                LastName = "2",
                Gender = Gender.Female,
                DateCreated = _dateTime,
                MedicalRecordId = 2
            },
            new User
            {
                Id = 5,
                IsActive = true,
                Email = "patient3@mail.com",
                NormalizedEmail = "Patient3@MAIL.COM",
                UserName = "patient3",
                NormalizedUserName = "PATIENT3",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1989, 5, 5),
                FirstName = "Patient",
                LastName = "3",
                Gender = Gender.Male,
                DateCreated = _dateTime,
                MedicalRecordId = 3
            }
        );
    }

    private void SeedNotifications(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Notification>().HasData(
            new Notification { Id = 1, UserId = 3, Message = "Dobrodošli u dermatološki centar! Vaš profil je aktiviran.", Read = false, DateCreated = new DateTime(2025, 5, 20, 9, 0, 0) },
            new Notification { Id = 2, UserId = 3, Message = "Termin pregleda potvrđen za 03.06.2025. u 11:00.", Read = true, DateCreated = new DateTime(2025, 5, 22, 14, 30, 0) },
            new Notification { Id = 3, UserId = 3, Message = "Vaši rezultati testiranja kože su spremni za preuzimanje.", Read = false, DateCreated = new DateTime(2025, 5, 25, 10, 15, 0) },

            new Notification { Id = 4, UserId = 4, Message = "Podsjetnik: tretman odstranjivanja madeža 05.06.2025. u 12:00.", Read = false, DateCreated = new DateTime(2025, 5, 21, 8, 45, 0) },
            new Notification { Id = 5, UserId = 4, Message = "Upute za pripremu kože prije tretmana su poslane na vašu e-poštu.", Read = true, DateCreated = new DateTime(2025, 5, 23, 9, 30, 0) },
            new Notification { Id = 6, UserId = 4, Message = "Novi savjet za njegu kože dostupan je na vašem profilu.", Read = false, DateCreated = new DateTime(2025, 5, 26, 16, 0, 0) },

            new Notification { Id = 7, UserId = 5, Message = "Vaš zahtjev za promjenu termina je odobren.", Read = true, DateCreated = new DateTime(2025, 5, 19, 13, 20, 0) },
            new Notification { Id = 8, UserId = 5, Message = "Podsjetnik: savjetovanje s dermatologom sutra u 10:00.", Read = false, DateCreated = new DateTime(2025, 5, 27, 7, 0, 0) },
            new Notification { Id = 9, UserId = 5, Message = "Ponuda: 10% popusta na paket tretmana lica.", Read = false, DateCreated = new DateTime(2025, 5, 28, 12, 0, 0) }
        );
    }

    private void SeedRoles(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Role>().HasData(
            new Role
            {
                Id = 1,
                RoleLevel = RoleLevel.Administrator,
                DateCreated = _dateTime,
                Name = "Administrator",
                NormalizedName = "ADMINISTRATOR",
                ConcurrencyStamp = Guid.NewGuid().ToString()
            },
             new Role
             {
                 Id = 2,
                 RoleLevel = RoleLevel.Employee,
                 DateCreated = _dateTime,
                 Name = "Employee",
                 NormalizedName = "EMPLOYEE",
                 ConcurrencyStamp = Guid.NewGuid().ToString()
             },
             new Role
             {
                 Id = 3,
                 RoleLevel = RoleLevel.Patient,
                 DateCreated = _dateTime,
                 Name = "Patient",
                 NormalizedName = "PATIENT",
                 ConcurrencyStamp = Guid.NewGuid().ToString()
             }
        );
    }
    private void SeedUserRoles(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<UserRole>().HasData(
            new UserRole
            {
                Id = 1,
                DateCreated = _dateTime,
                UserId = 1,
                RoleId = 1
            },
             new UserRole
             {
                 Id = 2,
                 DateCreated = _dateTime,
                 UserId = 2,
                 RoleId = 2
             },
              new UserRole
              {
                  Id = 3,
                  DateCreated = _dateTime,
                  UserId = 3,
                  RoleId = 3
              },
              new UserRole
              {
                  Id = 4,
                  DateCreated = _dateTime,
                  UserId = 4,
                  RoleId = 3
              },
              new UserRole
              {
                  Id = 5,
                  DateCreated = _dateTime,
                  UserId = 5,
                  RoleId = 3
              }
        );
    }

    private void SeedMedicalRecords(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<MedicalRecord>().HasData(
            new MedicalRecord
            {
                Id = 1,
                Diagnoses = "Akne vulgaris",
                Allergies = "Nema poznatih alergija",
                Treatments = "Lokalna terapija benzoil peroksidom, antibiotska krema",
                Notes = "Pacijentu savjetovana higijena lica i izbjegavanje masne hrane.",
                BloodType = "A+",
                Height = 178.0m,
                Weight = 74.0m,
            },
            new MedicalRecord
            {
                Id = 2,
                Diagnoses = "Psorijaza",
                Allergies = "Alergija na kortikosteroide",
                Treatments = "Topikalni kortikosteroidi (niskog intenziteta), UVB terapija",
                Notes = "Praćenje kroz naredna tri mjeseca, izbjegavati stres.",
                BloodType = "B-",
                Height = 165.0m,
                Weight = 68.5m,
            },
            new MedicalRecord
            {
                Id = 3,
                Diagnoses = "Atopijski dermatitis",
                Allergies = "Prašina, nikal",
                Treatments = "Hidratantne kreme, antihistaminici",
                Notes = "Preporučena upotreba blagih sapuna i izbjegavanje iritansa.",
                BloodType = "AB+",
                Height = 172.5m,
                Weight = 61.0m,
            },
            new MedicalRecord
            {
                Id = 4,
                Diagnoses = "Kontaktni dermatitis",
                Allergies = "Lateks",
                Treatments = "Izbjegavanje alergena, kortikosteroidna mast",
                Notes = "Kožne promjene prisutne na rukama, praćenje reakcije na terapiju.",
                BloodType = "O+",
                Height = 180.0m,
                Weight = 85.0m,
            },
            new MedicalRecord
            {
                Id = 5,
                Diagnoses = "Seboroični dermatitis",
                Allergies = "Nema",
                Treatments = "Šampon s ketokonazolom, krema sa cinkom",
                Notes = "Promjene izražene na vlasištu i iza ušiju.",
                BloodType = "A-",
                Height = 169.5m,
                Weight = 70.0m,
            }
        );
    }

    private void SeedServices(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Service>().HasData(
            new Service
            {
                Id = 1,
                Name = "Konsultacija kože",
                Duration = TimeSpan.FromMinutes(10),
                DateCreated = _dateTime,
                IsDeleted = false,
            },
            new Service
            {
                Id = 2,
                Name = "Tretman akni",
                Duration = TimeSpan.FromMinutes(20),
                DateCreated = _dateTime,
                IsDeleted = false,
            },
            new Service
            {
                Id = 3,
                Name = "Uklanjanje mladeža",
                Duration = TimeSpan.FromMinutes(30),
                DateCreated = _dateTime,
                IsDeleted = false,
            },
            new Service
            {
                Id = 4,
                Name = "Laser terapija",
                Duration = TimeSpan.FromMinutes(35),
                DateCreated = _dateTime,
                IsDeleted = false,
            },
            new Service
            {
                Id = 5,
                Name = "Hemijski piling",
                Duration = TimeSpan.FromMinutes(40),
                DateCreated = _dateTime,
                IsDeleted = false,
            }
        );
    }

    private void SeedProductCategoriesAndProducts(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ProductCategory>().HasData(
            new ProductCategory { Id = 1, Name = "Njega lica", DateCreated = _dateTime, IsDeleted = false },
            new ProductCategory { Id = 2, Name = "Njega tijela", DateCreated = _dateTime, IsDeleted = false },
            new ProductCategory { Id = 3, Name = "Dodaci prehrani", DateCreated = _dateTime, IsDeleted = false }
        );

        modelBuilder.Entity<Product>().HasData(
            new Product
            {
                Id = 1,
                Name = "Hidratantna krema",
                Description = "Krema za dubinsku hidrataciju suhe kože.",
                Price = 19.99m,
                Stock = 100,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "Dermaline",
                Barcode = "1234567890123",
                Ingredients = "Aqua, Glycerin, Aloe Vera",
                ProductCategoryId = 1,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 2,
                Name = "Krema za akne",
                Description = "Specijalizovana krema za tretman akni i mitesera.",
                Price = 22.50m,
                Stock = 80,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "AcneFix",
                Barcode = "1112223330000",
                Ingredients = "Salicylic Acid, Tea Tree Oil",
                ProductCategoryId = 1,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 3,
                Name = "Noćna anti-age krema",
                Description = "Regenerišuća noćna krema protiv bora.",
                Price = 29.90m,
                Stock = 60,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "YouthSkin",
                Barcode = "4567891234567",
                Ingredients = "Retinol, Hyaluronic Acid",
                ProductCategoryId = 1,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 4,
                Name = "Micelarna voda",
                Description = "Micelarna voda za uklanjanje šminke i nečistoća.",
                Price = 11.99m,
                Stock = 120,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "CleanFace",
                Barcode = "8887776665554",
                Ingredients = "Aqua, Micelles, Chamomile Extract",
                ProductCategoryId = 1,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 5,
                Name = "Maska za lice - glina",
                Description = "Prirodna maska sa zelenom glinom za čišćenje pora.",
                Price = 13.75m,
                Stock = 95,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "NatureBeauty",
                Barcode = "9090901234567",
                Ingredients = "Green Clay, Aloe Vera",
                ProductCategoryId = 1,
                DateCreated = _dateTime,
                IsDeleted = false
            },

            new Product
            {
                Id = 6,
                Name = "Gel za tuširanje",
                Description = "Osvježavajući gel za tuširanje sa citrusima.",
                Price = 9.49m,
                Stock = 200,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "BodyFresh",
                Barcode = "9876543210987",
                Ingredients = "Aqua, Sodium Laureth Sulfate, Citrus Extract",
                ProductCategoryId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 7,
                Name = "Losion za tijelo",
                Description = "Hidratantni losion za svakodnevnu njegu kože tijela.",
                Price = 12.30m,
                Stock = 150,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "SoftSkin",
                Barcode = "3332221114448",
                Ingredients = "Shea Butter, Vitamin E",
                ProductCategoryId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 8,
                Name = "Krema za ruke",
                Description = "Bogata krema za njegu i zaštitu ruku.",
                Price = 5.99m,
                Stock = 300,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "CareHands",
                Barcode = "5656565656565",
                Ingredients = "Glycerin, Panthenol",
                ProductCategoryId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 9,
                Name = "Ulje za masažu",
                Description = "Prirodno ulje za relaksirajuću masažu.",
                Price = 18.00m,
                Stock = 70,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "RelaxTime",
                Barcode = "7778889991112",
                Ingredients = "Lavender Oil, Almond Oil",
                ProductCategoryId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 10,
                Name = "Piling za tijelo",
                Description = "Piling sa morskom soli za glatku kožu.",
                Price = 15.90m,
                Stock = 85,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "SeaBeauty",
                Barcode = "2223334445556",
                Ingredients = "Sea Salt, Coconut Oil",
                ProductCategoryId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },

            new Product
            {
                Id = 11,
                Name = "Multivitamin kapsule",
                Description = "Kompleks vitamina i minerala za svakodnevnu upotrebu.",
                Price = 14.99m,
                Stock = 150,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "NutriLife",
                Barcode = "1112223334445",
                Ingredients = "Vitamin A, C, D, E, Zinc, Iron",
                ProductCategoryId = 3,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 12,
                Name = "Omega 3 kapsule",
                Description = "Kapsule ribljeg ulja bogate omega-3 masnim kiselinama.",
                Price = 17.49m,
                Stock = 130,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "HeartWell",
                Barcode = "0001112223334",
                Ingredients = "Fish Oil, EPA, DHA",
                ProductCategoryId = 3,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 13,
                Name = "Vitamin C tablete",
                Description = "Tablete vitamina C za jačanje imuniteta.",
                Price = 6.99m,
                Stock = 180,
                ImageUrl = "https://logotyp.us/file/dm.svgg",
                IsEnable = true,
                Manufacturer = "C-Boost",
                Barcode = "4445556667778",
                Ingredients = "Vitamin C, Citrus Bioflavonoids",
                ProductCategoryId = 3,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 14,
                Name = "Probiotik kapsule",
                Description = "Probiotici za zdravlje crijeva.",
                Price = 16.75m,
                Stock = 110,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "GutHealth",
                Barcode = "5556667778889",
                Ingredients = "Lactobacillus, Bifidobacterium",
                ProductCategoryId = 3,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Product
            {
                Id = 15,
                Name = "Magnezijum tablete",
                Description = "Tablete za podršku nervnom sistemu i mišićima.",
                Price = 8.20m,
                Stock = 140,
                ImageUrl = "https://logotyp.us/file/dm.svg",
                IsEnable = true,
                Manufacturer = "VitalPower",
                Barcode = "6667778889990",
                Ingredients = "Magnesium Citrate",
                ProductCategoryId = 3,
                DateCreated = _dateTime,
                IsDeleted = false
            }
        );
    }

    public void SeedOrders(ModelBuilder modelBuilder)
    {
        int orderId = 1;
        int itemId = 1;

        var orders = new List<Order>();
        var orderItems = new List<OrderItem>();

        var rnd = new Random();

        foreach (var patientId in new[] { 3, 4, 5 })
        {
            for (int i = 0; i < 3; i++)
            {
                var order = new Order
                {
                    Id = orderId,
                    PatientId = patientId,
                    TransactionId = $"i_{orderId:D4}",
                    FullName = $"Pacijent {patientId}",
                    Address = $"Adresa {patientId}",
                    PhoneNumber = $"061-{100000 + patientId * 10 + i}",
                    PaymentMethod = "kartica",
                    DeliveryMethod = "dostavaa",
                    Note = $"Napomena za narudžbu {orderId}",
                    Status = OrderStatus.Delivered,
                    Date = DateTime.UtcNow.AddDays(-rnd.Next(10, 100))
                };

                orders.Add(order);

                var numItems = rnd.Next(2, 5);
                var selectedProductIds = Enumerable.Range(1, 15).OrderBy(_ => rnd.Next()).Take(numItems).ToList();

                foreach (var productId in selectedProductIds)
                {
                    var quantity = rnd.Next(1, 3);
                    var unitPrice = rnd.Next(15, 60);

                    var item = new OrderItem
                    {
                        Id = itemId++,
                        OrderId = orderId,
                        ProductId = productId,
                        Quantity = quantity,
                        UnitPrice = unitPrice
                    };

                    order.TotalAmount += item.TotalPrice;
                    orderItems.Add(item);
                }

                orderId++;
            }
        }

        modelBuilder.Entity<Order>().HasData(orders);
        modelBuilder.Entity<OrderItem>().HasData(orderItems);
    }
}
