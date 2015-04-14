using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate;
using NHibernate.SqlCommand;
using Gotham.Model.Tools;

namespace GOTHAM.Repository.Abstract
{
    public class UnitOfWork : IUnitOfWork
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private readonly ISessionFactory _sessionFactory;
        private ITransaction _transaction;
        private Dictionary<Type, object> _repositories;
        private string checksum;
        private bool _disposed = false;

        public ISession Session { get; private set; }

        public UnitOfWork()
        {
            checksum = Guid.NewGuid().ToString();

            Log.Debug("["+checksum+"] Starting Unit Of Work...");
            _repositories = new Dictionary<Type, object>(); // TODO
            _sessionFactory = EntityManager.GetSessionFactory();
            Session = _sessionFactory.OpenSession();
        }

        public IReadWriteRepository<TEntity> GetRepository<TEntity>() where TEntity : class
        {

            Log.Debug("["+checksum+"] Retrieving Repository with type '" + typeof(TEntity).Name + "'");
            IsDisposed();
            foreach (var key in _repositories.Keys)
            {
                if (key == typeof(TEntity))
                {
                    return _repositories[typeof(TEntity)] as IReadWriteRepository<TEntity>;
                }
            }

            var repository = new Repository<TEntity>(Session);
            _repositories.Add(typeof(TEntity), repository);
            return repository;
        }

        public ITransaction BeginTransaction()
        {
            Log.Debug("[" + checksum + "] Starting transaction...");

            IsDisposed();
            if (_transaction != null)
            {
                throw new InvalidOperationException("[" + checksum + "] Cannot have more than one transaction per session.");
            }
            _transaction = Session.BeginTransaction(IsolationLevel.ReadCommitted);
            return _transaction;
        }

        public void Commit()
        {
            Log.Debug("[" + checksum + "] Committing Changes...");
            IsDisposed();
            if (!_transaction.IsActive)
            {
                throw new InvalidOperationException("[" + checksum + "] Cannot commit to inactive transaction.");
            }
            _transaction.Commit();
        }

        public void Rollback()
        {
            if (_transaction.IsActive)
            {
                _transaction.Rollback();
            }
        }

        public void IsDisposed()
        {
            if (_disposed)
                throw new InvalidOperationException("[" + checksum + "] Is Already disposed!");
        }

        public void Dispose()
        {
            Log.Debug("["+checksum+"] Disposing UnitOfWork");
            if (Session != null)
            {
                Session.Dispose();
            }
            if (_transaction != null)
            {
                _transaction.Dispose();
            }

            _disposed = true;
        }
    }
}
