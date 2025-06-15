namespace CrystalSkin.Services;

public interface IUsersService : IBaseService<int, UserModel, UserUpsertModel, UsersSearchObject>
{
    Task<UserLoginDataModel?> FindByUserNameOrEmailAsync(string userName, CancellationToken cancellationToken = default);
    Task<int> PatientCount(CancellationToken cancellationToken = default);
    Task<int> EmployeeCount(CancellationToken cancellationToken = default);
    Task<Dictionary<DateTime, int>> GetDailyPatientRegistrationsAsync(CancellationToken cancellationToken = default);
    Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesDropdownItems();
    Task<IEnumerable<KeyValuePair<int, string>>> GetPatientsDropdownItems();
}
